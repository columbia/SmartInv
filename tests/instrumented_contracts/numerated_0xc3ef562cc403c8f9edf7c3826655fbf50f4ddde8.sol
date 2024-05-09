1 pragma solidity ^0.4.2;
2 
3 
4 /* define 'owned' */
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         if (msg.sender != owner) throw;
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner {
18         owner = newOwner;
19     }
20 }
21 
22 contract StableBalance is owned {
23  
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Tx(address _to, uint256 _value,string _txt);
26     
27     mapping (address => uint256) balances;
28     
29     function transfer(address _to, uint256 _value) returns (bool success) { return false; throw;}
30     
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balances[_owner];
33     }
34     
35     function addTx(address _to, uint256 _value,string _txt) onlyOwner {
36         balances[_to]+=_value;
37         Tx(_to,_value,_txt);
38     }
39     
40 }
41 contract StableBalancer is owned {
42  
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Tx(address _from,address _to, uint256 _value,string _txt);
45     
46     mapping (address => uint256) balancesHaben;
47     mapping (address => uint256) balancesSoll;
48     
49     function transfer(address _to, uint256 _value) returns (bool success) { return false; throw;}
50     
51     function balanceHaben(address _owner) constant returns (uint256 balance) {
52         return balancesHaben[_owner];
53     }
54     
55     function balanceSoll(address _owner) constant returns (uint256 balance) {
56         return balancesSoll[_owner];
57     }
58     
59     function addTx(address _from,address _to, uint256 _value,string _txt) onlyOwner {
60         balancesSoll[_from]+=_value;
61         balancesHaben[_to]+=_value;
62         Tx(_from,_to,_value,_txt);
63     }
64     
65 }
66 
67 contract StableStore {
68     
69     mapping (address => string) public store;
70     
71     function setValue(string _value) {
72         store[msg.sender]=_value;
73     }
74 }
75 
76 contract StableAddressStore {
77     mapping (address => mapping(address=>string)) public store;
78     
79     function setValue(address key,string _value) {
80         store[msg.sender][key]=_value;
81     }
82 }
83 
84 contract StableTxStore {
85     mapping (address => mapping(address=>tx)) public store;
86     
87     struct tx {
88         uint256 amount;
89         uint256 repeatMinutes;
90         uint256 repeatTimes;
91     }
92     
93     function setValue(address key,uint256 amount,uint256 repeatMinutes,uint256 repeatTimes) {
94         store[msg.sender][key]=tx(amount,repeatMinutes,repeatTimes);
95     }
96 }