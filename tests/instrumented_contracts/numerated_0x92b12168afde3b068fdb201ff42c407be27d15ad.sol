1 pragma solidity ^0.4.25;
2 
3 contract Gravestone {
4 	/* name of the departed person */
5 	string public fullname;
6 	/* birth date of the person */
7 	string public birth_date;
8 	/* death date of the person */
9 	string public death_date;
10 	
11 	/* the message engraved on the gravestone */
12 	string public epitaph;
13 	
14     /* worships to the departed */
15     Worship[] public worships;
16 	uint public worship_count;
17 	
18 	/* This runs when the contract is executed */
19 	constructor(string _fullname,string _birth_date,string _death_date,string _epitaph) public {
20 		fullname = _fullname;
21 		birth_date = _birth_date;
22 		death_date = _death_date;
23 		epitaph = _epitaph;
24 	}
25 
26     /* worship the departed */
27     function do_worship(string _fullname,string _message) public returns (string) {
28 		uint id = worships.length++;
29 		worship_count = worships.length;
30 		worships[id] = Worship({fullname: _fullname, message: _message});
31         return "Thank you";
32     }
33 	
34 	struct Worship {
35 		/* full name of the worship person */
36 		string fullname;
37 		/* message to the departed */
38 		string message;
39 	}
40 }
41 
42 contract JinYongGravestone is Gravestone {
43 	constructor() Gravestone("金庸","1924年3月10日","2018年10月30日","这里躺着一个人，在二十世纪、二十一世纪，他写过几十部武侠小说，这些小说为几亿人喜欢。") public {}
44 }