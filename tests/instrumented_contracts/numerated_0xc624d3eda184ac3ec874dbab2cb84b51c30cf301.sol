1 pragma solidity ^0.4.25;
2 
3 contract Gravestone {
4 	Departed public departed;
5 	
6 	/* the message engraved on the gravestone */
7 	string public epitaph;
8 	
9     /* worships to the departed */
10     Worship[] public worships;
11 	uint public worship_count;
12 	
13 	/* This runs when the contract is executed */
14 	constructor(string _fullname,string _birth_date,string _death_date,string _epitaph) public {
15 		departed = Departed({fullname: _fullname, birth_date: _birth_date, death_date: _death_date});
16 		epitaph = _epitaph;
17 	}
18 
19     /* worship the departed */
20     function do_worship(string _fullname,string _message) public returns (string) {
21 		uint id = worships.length++;
22 		worship_count = worships.length;
23 		worships[id] = Worship({fullname: _fullname, message: _message});
24         return "Thank you";
25     }
26 	
27 	struct Departed {
28 		/* name of the person */
29 		string fullname;
30 		/* birth date of the person */
31 		string birth_date;
32 		/* death date of the person */
33 		string death_date;
34 	}
35 	
36 	struct Worship {
37 		/* full name of the worship person */
38 		string fullname;
39 		/* message to the departed */
40 		string message;
41 	}
42 }
43 
44 contract JinYongGravestone is Gravestone {
45 	constructor() Gravestone("金庸","1924年3月10日","2018年10月30日","这里躺着一个人，在二十世纪、二十一世纪，他写过几十部武侠小说，这些小说为几亿人喜欢。") public {}
46 }