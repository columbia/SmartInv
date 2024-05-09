1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // BokkyPooBah's Pricefeed from a single source
5 //
6 // Deployed to: 0xD649c9b68BB78e8fd25c0B7a9c22c42f57768c91
7 //
8 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 
12 
13 // ----------------------------------------------------------------------------
14 // Owned contract
15 // ----------------------------------------------------------------------------
16 contract Owned {
17     address public owner;
18     address public newOwner;
19     bool private initialised;
20 
21     event OwnershipTransferred(address indexed _from, address indexed _to);
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function initOwned(address _owner) internal {
29         require(!initialised);
30         owner = _owner;
31         initialised = true;
32     }
33     function transferOwnership(address _newOwner) public onlyOwner {
34         newOwner = _newOwner;
35     }
36     function acceptOwnership() public {
37         require(msg.sender == newOwner);
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40         newOwner = address(0);
41     }
42     function transferOwnershipImmediately(address _newOwner) public onlyOwner {
43         emit OwnershipTransferred(owner, _newOwner);
44         owner = _newOwner;
45     }
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Maintain a list of operators that are permissioned to execute certain
51 // functions
52 // ----------------------------------------------------------------------------
53 contract Operated is Owned {
54     mapping(address => bool) public operators;
55 
56     event OperatorAdded(address _operator);
57     event OperatorRemoved(address _operator);
58 
59     modifier onlyOperator() {
60         require(operators[msg.sender] || owner == msg.sender);
61         _;
62     }
63 
64     function initOperated(address _owner) internal {
65         initOwned(_owner);
66     }
67     function addOperator(address _operator) public onlyOwner {
68         require(!operators[_operator]);
69         operators[_operator] = true;
70         emit OperatorAdded(_operator);
71     }
72     function removeOperator(address _operator) public onlyOwner {
73         require(operators[_operator]);
74         delete operators[_operator];
75         emit OperatorRemoved(_operator);
76     }
77 }
78 
79 // ----------------------------------------------------------------------------
80 // PriceFeed Interface - _live is true if the rate is valid, false if invalid
81 // ----------------------------------------------------------------------------
82 contract PriceFeedInterface {
83     function name() public view returns (string);
84     function getRate() public view returns (uint _rate, bool _live);
85 }
86 
87 
88 // ----------------------------------------------------------------------------
89 // Pricefeed from a single source
90 // ----------------------------------------------------------------------------
91 contract PriceFeed is PriceFeedInterface, Operated {
92     string private _name;
93     uint private _rate;
94     bool private _live;
95 
96     event SetRate(uint oldRate, bool oldLive, uint newRate, bool newLive);
97 
98     constructor(string name, uint rate, bool live) public {
99         initOperated(msg.sender);
100         _name = name;
101         _rate = rate;
102         _live = live;
103         emit SetRate(0, false, _rate, _live);
104     }
105     function name() public view returns (string) {
106         return _name;
107     }
108     function setRate(uint rate, bool live) public onlyOperator {
109         emit SetRate(_rate, _live, rate, live);
110         _rate = rate;
111         _live = live;
112     }
113     function getRate() public view returns (uint rate, bool live) {
114         return (_rate, _live);
115     }
116 }