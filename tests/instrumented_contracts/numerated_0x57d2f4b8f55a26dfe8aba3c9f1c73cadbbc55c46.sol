1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // GazeCoin FxxxLandRush Bonus List
5 //
6 // Deployed to: 0x57D2F4B8F55A26DfE8Aba3c9f1c73CADbBc55C46
7 //
8 // Enjoy.
9 //
10 // (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2018. The MIT Licence.
11 // ----------------------------------------------------------------------------
12 
13 
14 
15 // ----------------------------------------------------------------------------
16 // Owned contract
17 // ----------------------------------------------------------------------------
18 contract Owned {
19     address public owner;
20     address public newOwner;
21     bool private initialised;
22 
23     event OwnershipTransferred(address indexed _from, address indexed _to);
24 
25     modifier onlyOwner {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     function initOwned(address _owner) internal {
31         require(!initialised);
32         owner = _owner;
33         initialised = true;
34     }
35     function transferOwnership(address _newOwner) public onlyOwner {
36         newOwner = _newOwner;
37     }
38     function acceptOwnership() public {
39         require(msg.sender == newOwner);
40         emit OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42         newOwner = address(0);
43     }
44     function transferOwnershipImmediately(address _newOwner) public onlyOwner {
45         emit OwnershipTransferred(owner, _newOwner);
46         owner = _newOwner;
47     }
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Maintain a list of operators that are permissioned to execute certain
53 // functions
54 // ----------------------------------------------------------------------------
55 contract Operated is Owned {
56     mapping(address => bool) public operators;
57 
58     event OperatorAdded(address _operator);
59     event OperatorRemoved(address _operator);
60 
61     modifier onlyOperator() {
62         require(operators[msg.sender] || owner == msg.sender);
63         _;
64     }
65 
66     function initOperated(address _owner) internal {
67         initOwned(_owner);
68     }
69     function addOperator(address _operator) public onlyOwner {
70         require(!operators[_operator]);
71         operators[_operator] = true;
72         emit OperatorAdded(_operator);
73     }
74     function removeOperator(address _operator) public onlyOwner {
75         require(operators[_operator]);
76         delete operators[_operator];
77         emit OperatorRemoved(_operator);
78     }
79 }
80 
81 // ----------------------------------------------------------------------------
82 // Bonus List interface
83 // ----------------------------------------------------------------------------
84 contract BonusListInterface {
85     function isInBonusList(address account) public view returns (bool);
86 }
87 
88 
89 // ----------------------------------------------------------------------------
90 // Bonus List - on list or not
91 // ----------------------------------------------------------------------------
92 contract BonusList is BonusListInterface, Operated {
93     mapping(address => bool) public bonusList;
94 
95     event AccountListed(address indexed account, bool status);
96 
97     constructor() public {
98         initOperated(msg.sender);
99     }
100 
101     function isInBonusList(address account) public view returns (bool) {
102         return bonusList[account];
103     }
104 
105     function add(address[] accounts) public onlyOperator {
106         require(accounts.length != 0);
107         for (uint i = 0; i < accounts.length; i++) {
108             require(accounts[i] != address(0));
109             if (!bonusList[accounts[i]]) {
110                 bonusList[accounts[i]] = true;
111                 emit AccountListed(accounts[i], true);
112             }
113         }
114     }
115     function remove(address[] accounts) public onlyOperator {
116         require(accounts.length != 0);
117         for (uint i = 0; i < accounts.length; i++) {
118             require(accounts[i] != address(0));
119             if (bonusList[accounts[i]]) {
120                 delete bonusList[accounts[i]];
121                 emit AccountListed(accounts[i], false);
122             }
123         }
124     }
125 }