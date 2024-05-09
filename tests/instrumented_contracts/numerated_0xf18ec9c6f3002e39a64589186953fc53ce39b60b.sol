1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-12
3 */
4 
5 pragma solidity ^0.4.25;
6 
7 contract Utils {
8     modifier validAddress(address _address) {
9         require(_address != address(0));
10         _;
11     }
12 
13     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
14         uint256 _z = _x + _y;
15         assert(_z >= _x);
16         return _z;
17     }
18 
19     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
20         assert(_x >= _y);
21         return _x - _y;
22     }
23 
24     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
25         uint256 _z = _x * _y;
26         assert(_x == 0 || _z / _x == _y);
27         return _z;
28     }
29     
30     function safeDiv(uint256 _x, uint256 _y) internal pure returns (uint256) {
31         assert(_y != 0); 
32         uint256 _z = _x / _y;
33         assert(_x == _y * _z + _x % _y); 
34         return _z;
35     }
36 
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     function Ownable() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50     function transferOwnership(address newOwner) onlyOwner public {
51         require(newOwner != address(0));
52         owner = newOwner;
53     }
54 }
55 
56 contract ERC20Token {
57     function balanceOf(address who) public constant returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60 }
61 
62 contract StandardToken is ERC20Token, Utils, Ownable {
63  
64     bool public transfersEnabled = true;  
65     
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowed;
68 
69     modifier transfersAllowed {
70         assert(transfersEnabled);
71         _;
72     }
73 
74     function disableTransfers(bool _disable) public onlyOwner {
75         transfersEnabled = !_disable;
76     }
77     
78     function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed returns (bool success){
79         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value > balanceOf[_to]); 
80         
81         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
82         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
83         Transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) public validAddress(_owner) constant returns (uint256 balance) {
88         return balanceOf[_owner];
89     }
90 
91 }
92 
93 contract XG is StandardToken {
94 
95     string public constant name = "XG";
96     string public constant symbol = "XG"; 
97     uint8 public constant decimals = 18;
98     uint256 public totalSupply = 2 * 10**27;
99     address public constant OwnerWallet = 0x8080B29736964897B87Fd70530bdD38AB269Ec5e;
100     
101     function XG(){
102         balanceOf[OwnerWallet] = totalSupply;
103         
104         Transfer(0x0, OwnerWallet, balanceOf[OwnerWallet]);
105     }
106 }