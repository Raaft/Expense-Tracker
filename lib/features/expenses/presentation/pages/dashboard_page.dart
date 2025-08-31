// lib/features/expenses/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../blocs/list_expenses/list_expenses_bloc.dart';
import '../blocs/list_expenses/list_expenses_event.dart';
import '../blocs/list_expenses/list_expenses_state.dart';
import '../pages/add_expense_page.dart';
import '../widgets/expense_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<ListExpensesBloc>();
      if (!bloc.state.loading && bloc.state.hasMore) {
        bloc.add( LoadNextPage());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  static const String _balanceTxt = '\$ 2,548.00';
  static const String _incomeTxt = '\$10,840.00';
  static const String _expensesTxt = '\$1,884.00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),

      body: SafeArea(
        top: false,
        child: BlocBuilder<ListExpensesBloc, ListExpensesState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(context),

                SizedBox(height: 18.h),

                // ------- Recent title row -------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Expenses',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w700)),
                      TextButton(
                        onPressed: () {},
                        child: Text('see all',
                            style: TextStyle(
                                color: Colors.blue, fontSize: 14.sp)),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: state.loading && state.items.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : state.items.isEmpty
                      ? const Center(child: Text('No expenses yet'))
                      : ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 90.h),
                    itemCount: state.hasMore ? state.items.length + 1 : state.items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final expense = state.items[index];

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 30.0,
                          child: FadeInAnimation(
                            child: ExpenseTile(expense: expense),
                          ),
                        ),
                      );
                    },
                  )
                  ,
                ),
              ],
            );
          },
        ),
      ),


      bottomNavigationBar: BottomAppBar(
      height: 75.sp,

        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            IconButton(
              onPressed: () => setState(() => _selectedIndex = 0),
              icon: Icon(Icons.home,size: 30.sp,
                  color: _selectedIndex == 0 ? const Color(0xFF246BFD) : Colors.grey),
            ),
            IconButton(
              onPressed: () => setState(() => _selectedIndex = 1),
              icon: Icon(Icons.bar_chart,size: 30.sp,
                  color: _selectedIndex == 1 ? const Color(0xFF246BFD) : Colors.grey),
            ),

            CircleAvatar(
              radius: 50.sp,
              backgroundColor: Colors.blue,
              child: IconButton(

                onPressed: () async {
                  final res = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => const AddExpensePage()),
                  );

                  if (res == true) {
                    context.read<ListExpensesBloc>().add(const LoadFirstPage());
                  }
                },
                icon: Icon(Icons.add,size: 25.sp,
                    color: Colors.white),
              ),
            ),



            IconButton(
              onPressed: () => setState(() => _selectedIndex = 2),
              icon: Icon(Icons.receipt_long,size: 30.sp,
                  color: _selectedIndex == 2 ? const Color(0xFF246BFD) : Colors.grey),
            ),
            IconButton(
              onPressed: () => setState(() => _selectedIndex = 3),
              icon: Icon(Icons.person,size: 30.sp,
                  color: _selectedIndex == 3 ? const Color(0xFF246BFD) : Colors.grey),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    return SizedBox(
      height: 280.h,
      child: Column(
        children: [
          Container(height: 50.h,           color: Color(0xFF246BFD),),

          Stack(
            clipBehavior: Clip.none,
            children: [

              Container(
                height: 180.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF246BFD),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                          radius: 20,
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good Morning',
                                style:
                                TextStyle(color: Colors.white70, fontSize: 12.sp)),
                            SizedBox(height: 4.h),
                            Text('Shihab Rahman',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Row(
                            children: [
                              Text('This month',
                                  style:
                                  TextStyle(color: Colors.black, fontSize: 12.sp)),
                              Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 18.w),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              // Balance Card positioned to overlap
              Positioned(
                left: 20.w,
                right: 20.w,
                top: 90.h,
                child: Container(
                  height: isTablet ? 170.h : 150.h,
                  padding: EdgeInsets.all(isTablet?5.w:16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF448AFF),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('Total Balance',
                                style:
                                TextStyle(color: Colors.white70, fontSize: 13.sp)),
                          ),
                          // three dots icon
                          Icon(Icons.more_horiz, color: Colors.white70, size: 20.w),
                        ],
                      ),
                    if(!isTablet)  SizedBox(height: 8.h),
                      Text(_balanceTxt,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800)),
                      if(!isTablet) const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Income
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: Colors.white24,
                                  child: Icon(Icons.arrow_downward,
                                      color: Colors.white, size: 16.w)),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Income', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                                  Text(_incomeTxt, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                                ],
                              )
                            ],
                          ),

                          // Expenses
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: Colors.white24,
                                  child: Icon(Icons.arrow_upward,
                                      color: Colors.white, size: 16.w)),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Expenses', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                                  Text(_expensesTxt, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

