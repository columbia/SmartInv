1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract BIWINToken {
30     using SafeMath for uint256;
31     string public name;
32     string public symbol;
33     uint8 public decimals = 18;
34     uint256 public totalSupply;
35     address public owner;
36     
37     address public betaAddress;
38     address public alphaAddress;
39     
40     mapping (address => uint256) public balanceOf;
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     
43     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, address alphaAddr, address betaAddr) {
44         totalSupply = initialSupply * 10 ** uint256(decimals);
45         name = tokenName;                                   
46         symbol = tokenSymbol;
47         betaAddress = betaAddr;
48         alphaAddress = alphaAddr;
49         owner = msg.sender;
50         balanceOf[alphaAddress] = totalSupply;
51         balanceOf[betaAddress] = 0;
52     }
53     modifier onlyGame() {
54         require(msg.sender == alphaAddress);
55         _;
56     }
57     
58     function queryBalanceOf(address addr) public returns(uint256) {
59         require(addr != 0x0);
60         return balanceOf[addr];
61     }
62     
63    function queryOwnerAddr() public constant returns(address) {
64         return owner;
65     }
66     
67     function _transfer(address from, address to, uint256 value) internal {
68         require(to != 0x0);
69         require(balanceOf[from] >= value);
70         require(balanceOf[to] + value > balanceOf[to]);
71         uint previousBalances = balanceOf[from] + balanceOf[to];
72         balanceOf[from] = balanceOf[from].sub(value);
73         balanceOf[to] = balanceOf[to].add(value);
74         Transfer(from, to, value);
75         assert(balanceOf[from] + balanceOf[to] == previousBalances);
76     }
77     function transferToBetaAddress(address to, uint256 value) onlyGame {
78         require(to == betaAddress);
79         _transfer(msg.sender, to, value);
80     }
81     
82     function transfer(address to, uint256 value) public {
83         require(to != betaAddress);
84         require(msg.sender != alphaAddress);
85         _transfer(msg.sender, to, value);
86     }
87 }