// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      'My Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Color(0xFFE5E5E5), shape: BoxShape.circle),
                        child: SizedBox(),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "MImamCh",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFF14193F)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ProfileItems(
                          title: 'Edit Profile', icon: Icon(Icons.people_alt)),
                      ProfileItems(title: 'My PIN', icon: Icon(Icons.security)),
                      ProfileItems(
                          title: 'Wallet Settings',
                          icon: Icon(Icons.wallet_giftcard)),
                      ProfileItems(
                          title: 'My Rewards', icon: Icon(Icons.badge)),
                      ProfileItems(
                          title: 'Help Center', icon: Icon(Icons.call)),
                      ProfileItems(
                          title: 'Log Out',
                          icon: Icon(Icons.door_back_door_outlined))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileItems extends StatefulWidget {
  Icon icon;
  String title;
  ProfileItems({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  State<ProfileItems> createState() => _ProfileItemsState();
}

class _ProfileItemsState extends State<ProfileItems> {
  get borderRadius => BorderRadius.circular(100);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Color.fromRGBO(229, 229, 229, 0.2),
        borderRadius: borderRadius,
        child: InkWell(
          splashColor: Color.fromRGBO(229, 229, 229, 0.5),
          borderRadius: borderRadius,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
              decoration: BoxDecoration(borderRadius: borderRadius),
              // margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  widget.icon,
                  SizedBox(
                    width: 18,
                  ),
                  Text(widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF14193F),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
