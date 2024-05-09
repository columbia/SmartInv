1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   address public agent; // sale agent
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27   
28   modifier onlyAgentOrOwner() {
29       require(msg.sender == owner || msg.sender == agent);
30       _;
31   }
32 
33   function setSaleAgent(address addr) public onlyOwner {
34       agent = addr;
35   }
36   
37 }
38 
39 contract HeartBoutToken is Ownable {
40     function transferTokents(address addr, uint256 tokens) public;
41 }
42 
43 contract HeartBoutSale is Ownable {
44     
45     uint32 rate = 10 ** 5;
46     
47     uint64 public startDate;
48     uint64 public endDate;
49     uint256 public soldOnCurrentSale = 0;
50     
51     mapping(string => address) addressByAccountMapping;
52 
53     HeartBoutToken tokenContract;
54     
55     function HeartBoutSale(HeartBoutToken _tokenContract) public {
56         tokenContract = _tokenContract;
57     }
58     
59     function startSale(uint32 _rate, uint64 _startDate, uint64 _endDate) public onlyOwner {
60         require(rate != 0);
61         require(_rate <= rate);
62         require(100 < _rate && _rate < 15000);
63         require(_endDate > now);
64         require(_startDate < _endDate);
65         
66         soldOnCurrentSale = 0;
67         
68         rate = _rate;
69         startDate = _startDate;
70         endDate = _endDate;
71     }
72     
73     function completeSale() public onlyOwner {
74         endDate = 0;
75         soldOnCurrentSale = 0;
76     }
77     
78     function () public payable {
79         revert();
80     }
81     
82     function buyTokens(string _account) public payable {
83         
84         require(msg.value > 0);
85         require(rate > 0);
86         require(endDate > now);
87         
88         require(msg.value >= (10 ** 16));
89         
90         uint256 tokens = msg.value * rate;
91         
92         address _to = msg.sender;
93         
94         if(addressByAccountMapping[_account] != 0x0) {
95             require(addressByAccountMapping[_account] == _to);      
96         }
97         addressByAccountMapping[_account] = _to;
98         
99         soldOnCurrentSale += tokens;
100 
101         tokenContract.transferTokents(msg.sender, tokens);
102         owner.transfer(msg.value);
103     }
104     
105     function getAddressForAccount(string _account) public view returns (address) {
106       return addressByAccountMapping[_account];
107     }
108     
109     function stringEqual(string a, string b) internal pure returns (bool) {
110       return keccak256(a) == keccak256(b);
111     }
112 }