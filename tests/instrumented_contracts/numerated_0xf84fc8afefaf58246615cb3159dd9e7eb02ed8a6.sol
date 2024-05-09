1 pragma solidity ^0.4.18;
2 
3 contract ERC223Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     function transfer(address to, uint256 value, bytes data) public returns (bool);
8     function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract ERC223 is ERC223Basic {
13     function allowance(address owner, address spender) public constant returns (uint256);
14     function transferFrom(address from, address to, uint256 value) public returns (bool);
15     function approve(address spender, uint256 value) public returns (bool);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 contract IOwned {
20     function owner() public pure returns (address) { owner; }
21     function transferOwnership(address _newOwner) public;
22     function acceptOwnership() public;
23 }
24 
25 contract Owned is IOwned {
26     
27     address public owner;
28     address public newOwner;
29 
30     event OwnerUpdate(address _prevOwner, address _newOwner);
31 
32     function Owned() public {
33         owner = msg.sender;
34     }
35 
36     modifier ownerOnly {
37         assert(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address _newOwner) public ownerOnly {
42         require(_newOwner != owner);
43         newOwner = _newOwner;
44     }
45 
46     /**
47         @dev used by a new owner to accept an ownership transfer
48     */
49     function acceptOwnership() public {
50         require(msg.sender == newOwner);
51         OwnerUpdate(owner, newOwner);
52         owner = newOwner;
53         newOwner = 0x0;
54     }
55 }
56 
57 contract LecStop is Owned{
58 
59     bool public stopped = false;
60 
61     modifier stoppable {
62         assert (!stopped);
63         _;
64     }
65     function stop() public ownerOnly{
66         stopped = true;
67     }
68     function start() public ownerOnly{
69         stopped = false;
70     }
71 
72 }
73 
74 
75 contract LecBatchTransfer is  Owned,LecStop{
76     
77     modifier validAddress(address _address) {
78         require(_address != 0x0);
79         _;
80     }
81     
82     modifier notThis(address _address) {
83         require(_address != address(this));
84         _;
85     }
86     
87     event LOG_Transfer_Contract(address indexed _from, uint256 _value, bytes indexed _data);
88 
89     function LecBatchTransfer() public{
90     }
91     
92     function tokenFallback(address _from, uint _value, bytes _data) public{
93         LOG_Transfer_Contract(_from, _value, _data);
94     }
95     
96     function batchTransfer(ERC223 _token,address[] _to,uint256 _amountOfEach) public 
97     ownerOnly stoppable validAddress(_token){
98         require(_to.length > 0 && _amountOfEach > 0 && _to.length * _amountOfEach <=  _token.balanceOf(this) && _to.length < 10000);
99         for(uint16 i = 0; i < _to.length ;i++){
100           assert(_token.transfer(_to[i],_amountOfEach));
101         }
102     }
103     
104     function withdrawTo(address _to, uint256 _amount)
105         public ownerOnly stoppable
106         notThis(_to)
107     {   
108         require(_amount <= this.balance);
109         _to.transfer(_amount); // send the amount to the target account
110     }
111     
112     function withdrawERC20TokenTo(ERC223 _token, address _to, uint256 _amount)
113         public
114         ownerOnly
115         validAddress(_token)
116         validAddress(_to)
117         notThis(_to)
118     {
119         assert(_token.transfer(_to, _amount));
120 
121     }
122 
123 }