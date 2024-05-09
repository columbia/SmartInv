1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract OwOToken {
30 
31     using SafeMath for uint256;
32 
33     string public constant symbol = "OWO";
34     string public constant name = "OwO.World Token";
35     uint public constant decimals = 18;
36     address public _multiSigWallet;  // The address to hold the funds donated
37     address public owner;
38     uint public totalSupply;
39     
40     /* This creates an array with all balances */
41     mapping (address => uint256) public balanceOf;
42     mapping(address => mapping(address => uint256)) allowed;
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46     // Crowdsale end time has been changed
47     event EndsAtChanged(uint endsAt);
48     event changed(address a);
49     
50     function () payable{
51         //
52     }
53 
54     /* Initializes contract with initial supply tokens to the creator of the contract */
55     function OwOToken() {
56         
57         owner = msg.sender;
58         totalSupply = 100000000 * 10 ** decimals;
59         balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
60         _multiSigWallet = 0x6c5140f605a9Add003B3626Aae4f08F41E6c6FfF;
61 
62     }
63 
64     /* Send coins */
65     function transfer(address _to, uint256 _value) returns(bool success){
66       require((balanceOf[msg.sender] >= _value) && (balanceOf[_to].add(_value)>balanceOf[_to]));
67         balanceOf[msg.sender].sub(_value);                     // Subtract from the sender
68         balanceOf[_to].add(_value);                            // Add the same to the recipient
69         Transfer(msg.sender, _to, _value);
70         return true;
71 
72     }
73 
74     modifier onlyOwner(){
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function setMultiSigWallet(address w) onlyOwner {
80         require(w != 0 );
81 
82           _multiSigWallet = w;
83 
84         changed(msg.sender);
85     }
86     function getMultiSigWallet() constant returns (address){
87 
88         return _multiSigWallet;
89 
90     }
91     function getMultiSigBalance() constant returns (uint){
92 
93         return balanceOf[_multiSigWallet];
94 
95     }
96     function getTotalSupply() constant returns (uint){
97 
98         return totalSupply;
99 
100     }
101     
102     function withdraw() onlyOwner payable{
103 
104          assert(_multiSigWallet.send(this.balance));
105 
106      }
107 
108 
109 }