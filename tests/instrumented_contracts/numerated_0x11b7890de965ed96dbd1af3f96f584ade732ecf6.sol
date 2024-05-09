1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     function div(uint a, uint b) internal returns (uint) {
10         assert(b > 0);
11         uint c = a / b;
12         assert(a == b * c + a % b);
13         return c;
14     }
15     function sub(uint a, uint b) internal returns (uint) {
16         assert(b <= a);
17         return a - b;
18      }
19     function add(uint a, uint b) internal returns (uint) {
20          uint c = a + b;
21          assert(c >= a);
22          return c;
23      }
24     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25         return a >= b ? a : b;
26      }
27 
28     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
29         return a < b ? a : b;
30     }
31 
32     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
33         return a >= b ? a : b;
34     }
35 
36     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
37         return a < b ? a : b;
38     }
39 }
40 
41 contract tokenLUCG {
42     /* Public variables of the token */
43         string public name;
44         string public symbol;
45         uint8 public decimals;
46         uint256 public totalSupply = 0;
47 
48 
49         function tokenLUCG (string _name, string _symbol, uint8 _decimals){
50             name = _name;
51             symbol = _symbol;
52             decimals = _decimals;
53 
54         }
55     /* This creates an array with all balances */
56         mapping (address => uint256) public balanceOf;
57 
58 }
59 
60 contract Presale is tokenLUCG {
61 
62         using SafeMath for uint;
63         string name = 'Level Up Coin Gold';
64         string symbol = 'LUCG';
65         uint8 decimals = 18;
66         address manager;
67         address public ico;
68 
69         function Presale (address _manager) tokenLUCG (name, symbol, decimals){
70              manager = _manager;
71 
72         }
73 
74         event Transfer(address _from, address _to, uint256 amount);
75         event Burn(address _from, uint256 amount);
76 
77         modifier onlyManager{
78              require(msg.sender == manager);
79             _;
80         }
81 
82         modifier onlyIco{
83              require(msg.sender == ico);
84             _;
85         }
86         function mintTokens(address _investor, uint256 _mintedAmount) public onlyManager {
87              balanceOf[_investor] = balanceOf[_investor].add(_mintedAmount);
88              totalSupply = totalSupply.add(_mintedAmount);
89              Transfer(this, _investor, _mintedAmount);
90 
91         }
92 
93         function burnTokens(address _owner) public onlyIco{
94              uint  tokens = balanceOf[_owner];
95              require(balanceOf[_owner] != 0);
96              balanceOf[_owner] = 0;
97              totalSupply = totalSupply.sub(tokens);
98              Burn(_owner, tokens);
99         }
100 
101         function setIco(address _ico) onlyManager{
102             ico = _ico;
103         }
104 }