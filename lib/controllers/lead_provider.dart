import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lead_model.dart';
import '../services/lead_db_service.dart';

final leadDbServiceProvider = Provider<LeadDbService>((ref) {
  return LeadDbService.instance;
});

// Pagination state
class PaginationState {
  final List<Lead> leads;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isLoading;

  PaginationState({
    required this.leads,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isLoading = false,
  });

  PaginationState copyWith({
    List<Lead>? leads,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isLoading,
  }) {
    return PaginationState(
      leads: leads ?? this.leads,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final leadListProvider =
    StateNotifierProvider<LeadListNotifier, PaginationState>((ref) {
  return LeadListNotifier(ref);
});

class LeadListNotifier extends StateNotifier<PaginationState> {
  final Ref ref;
  static const int _pageSize = 20;

  LeadListNotifier(this.ref)
      : super(PaginationState(
          leads: [],
          isLoading: true,
        )) {
    loadLeads();
  }

  Future<void> loadLeads({bool reset = true}) async {
    try {
      final filter = ref.read(filterProvider);
      final searchQuery = ref.read(searchProvider);

      if (reset) {
        state = state.copyWith(
          isLoading: true,
          currentPage: 0,
          leads: [],
        );
      }

      final leads = await ref.read(leadDbServiceProvider).getLeadsPaginated(
            limit: _pageSize,
            offset: 0,
            status: filter != 'All' ? filter : null,
            searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
          );

      final totalCount = await ref.read(leadDbServiceProvider).getLeadsCount(
            status: filter != 'All' ? filter : null,
            searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
          );

      state = state.copyWith(
        leads: leads,
        currentPage: 0,
        hasMore: leads.length < totalCount,
        isLoading: false,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<void> fetchMoreLeads() async {
    if (state.isLoadingMore || !state.hasMore) return;

    try {
      final filter = ref.read(filterProvider);
      final searchQuery = ref.read(searchProvider);

      state = state.copyWith(isLoadingMore: true);

      final nextPage = state.currentPage + 1;
      final leads = await ref.read(leadDbServiceProvider).getLeadsPaginated(
            limit: _pageSize,
            offset: nextPage * _pageSize,
            status: filter != 'All' ? filter : null,
            searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
          );

      final totalCount = await ref.read(leadDbServiceProvider).getLeadsCount(
            status: filter != 'All' ? filter : null,
            searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
          );

      final allLeads = [...state.leads, ...leads];
      final hasMore = allLeads.length < totalCount;

      state = state.copyWith(
        leads: allLeads,
        currentPage: nextPage,
        hasMore: hasMore,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> addLead(Lead lead) async {
    try {
      await ref.read(leadDbServiceProvider).insertLead(lead);
      await loadLeads(reset: true);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateLead(Lead lead) async {
    try {
      await ref.read(leadDbServiceProvider).updateLead(lead);
      await loadLeads(reset: true);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteLead(int id) async {
    try {
      await ref.read(leadDbServiceProvider).deleteLead(id);
      await loadLeads(reset: true);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> updateLeadStatus(int id, String status) async {
    try {
      final lead = await ref.read(leadDbServiceProvider).getLeadById(id);
      if (lead != null) {
        final updatedLead = lead.copyWith(status: status);
        await ref.read(leadDbServiceProvider).updateLead(updatedLead);
        await loadLeads(reset: true);
      }
    } catch (e) {
      // Handle error
    }
  }
}

final filterProvider = StateProvider<String>((ref) => 'All');

final searchProvider = StateProvider<String>((ref) => '');

// Watch for filter/search changes and reload
final filteredLeadsProvider = Provider<PaginationState>((ref) {
  final paginationState = ref.watch(leadListNotifierProvider);

  // Reload when filter or search changes
  ref.listen(filterProvider, (previous, next) {
    if (previous != next) {
      ref.read(leadListNotifierProvider.notifier).loadLeads(reset: true);
    }
  });

  ref.listen(searchProvider, (previous, next) {
    if (previous != next) {
      ref.read(leadListNotifierProvider.notifier).loadLeads(reset: true);
    }
  });

  return paginationState;
});

// Alias for easier access
final leadListNotifierProvider = leadListProvider;

// Provider for dashboard - gets all leads for statistics
final allLeadsProvider = FutureProvider<List<Lead>>((ref) async {
  final dbService = ref.read(leadDbServiceProvider);
  return await dbService.getAllLeads();
});
