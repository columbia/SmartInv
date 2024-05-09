1 pragma solidity ^0.4.25;
2 
3 contract Utils {
4     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
5         uint256 _z = _x + _y;
6         assert(_z >= _x);
7         return _z;
8     }
9 
10     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
11         assert(_x >= _y);
12         return _x - _y;
13     }
14 
15     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
16         uint256 _z = _x * _y;
17         assert(_x == 0 || _z / _x == _y);
18         return _z;
19     }
20     
21     function safeDiv(uint256 _x, uint256 _y) internal pure returns (uint256) {
22         assert(_y != 0); 
23         uint256 _z = _x / _y;
24         assert(_x == _y * _z + _x % _y); 
25         return _z;
26     }
27 
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     function Ownable() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41     function transferOwnership(address newOwner) onlyOwner public {
42         require(newOwner != address(0));
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20Token {
48     function balanceOf(address who) public constant returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51 }
52 
53 contract StandardToken is ERC20Token, Utils, Ownable {
54 
55     mapping (address => uint256) public balanceOf;
56     mapping (address => mapping (address => uint256)) public allowed;
57     
58     function transfer(address _to, uint256 _value) public returns (bool success){
59         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value > balanceOf[_to]); 
60         
61         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
62         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public constant returns (uint256 balance) {
68         return balanceOf[_owner];
69     }
70 
71 }
72 
73 contract SPRS is StandardToken {
74 
75     string public constant name = "SPRS";
76     string public constant symbol = "SPRS"; 
77     uint8 public constant decimals = 18;
78     uint256 public totalSupply = 10 * 10**26;
79     address public constant OwnerWallet = 0x35c55ca90873Ad5C7Ef7E15617bCf751e2F776a1;
80     
81     function SPRS(){
82         balanceOf[OwnerWallet] = totalSupply;
83         
84         Transfer(0x0, OwnerWallet, balanceOf[OwnerWallet]);
85     }
86 }