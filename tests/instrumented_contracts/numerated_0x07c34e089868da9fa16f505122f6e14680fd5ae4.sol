1 pragma solidity ^0.4.18;
2 
3 contract Utils {
4     modifier validAddress(address _address) {
5         require(_address != address(0));
6         _;
7     }
8 
9     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
10         uint256 _z = _x + _y;
11         assert(_z >= _x);
12         return _z;
13     }
14 
15     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
16         assert(_x >= _y);
17         return _x - _y;
18     }
19 
20     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
21         uint256 _z = _x * _y;
22         assert(_x == 0 || _z / _x == _y);
23         return _z;
24     }
25     
26     function safeDiv(uint256 _x, uint256 _y) internal pure returns (uint256) {
27         assert(_y != 0); 
28         uint256 _z = _x / _y;
29         assert(_x == _y * _z + _x % _y); 
30         return _z;
31     }
32 
33 }
34 
35 contract Ownable {
36     address public owner;
37 
38     function Ownable() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46     function transferOwnership(address newOwner) onlyOwner public {
47         require(newOwner != address(0));
48         owner = newOwner;
49     }
50 }
51 
52 contract ERC20Token {
53     function balanceOf(address who) public constant returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56 }
57 
58 contract StandardToken is ERC20Token, Utils, Ownable {
59  
60     bool public transfersEnabled = true;  
61     
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowed;
64 
65     modifier transfersAllowed {
66         assert(transfersEnabled);
67         _;
68     }
69 
70     function disableTransfers(bool _disable) public onlyOwner {
71         transfersEnabled = !_disable;
72     }
73     
74     function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed returns (bool success){
75         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value > balanceOf[_to]); 
76         
77         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
78         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
79         Transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function balanceOf(address _owner) public validAddress(_owner) constant returns (uint256 balance) {
84         return balanceOf[_owner];
85     }
86 
87 }
88 
89 contract ONECToken is StandardToken {
90 
91     string public constant name = "One Coin";
92     string public constant symbol = "ONEC"; 
93     uint8 public constant decimals = 18;
94     uint256 public constant totalSupply = 5.2 * 10**26;
95     
96     function ONECToken(){
97         balanceOf[owner] = totalSupply;
98         
99         Transfer(0x0, owner, balanceOf[owner]);
100     }
101 
102 }