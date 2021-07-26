import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopAppBar {
  static PreferredSizeWidget bar(context){
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Icon(Icons.center_focus_weak, size: 44.sp, color: Colors.black87),
            onTap: (){},
          ),
          SizedBox(width: 20.w,),
          Expanded(
              child: InkWell(
                child: Container(
                  height: 60.w,
                  padding: EdgeInsets.only(left: 20.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFd8d8d8),
                    borderRadius: BorderRadius.circular(30.w),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 40.sp, color: Colors.white),
                      SizedBox(width: 18.w,),
                      Text('笔记本', style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp
                      ))
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/search');
                },
              )
          ),
          SizedBox(width: 20.w,),
          InkWell(
            child: Icon(Icons.message, size: 44.sp, color: Colors.black87),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}
