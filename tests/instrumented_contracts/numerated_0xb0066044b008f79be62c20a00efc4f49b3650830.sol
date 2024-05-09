1 pragma solidity ^0.4.24;
2 
3 /**
4  * SmartEth.co
5  * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.
6  * contact@smarteth.co
7  */
8 
9 /**
10  * @title SafeMath
11  */
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 /**
43  * @title ERC20Basic
44  */
45 contract ERC20Basic {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 /**
53  * @title Bitway Coin
54  */
55 contract BTW_Token is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   uint256 totalSupply_;
61 
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   function transfer(address _to, uint256 _value) public returns (bool) {
67     require(_to != address(0));
68     require(_value <= balances[msg.sender]);
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     emit Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   function balanceOf(address _owner) public view returns (uint256 balance) {
76     return balances[_owner];
77   }
78     
79   string public name;
80   string public symbol;
81   uint8 public decimals;
82   address public owner;
83   uint256 public initialSupply;
84 
85   constructor() public {
86     name = 'Bitway Coin';
87     symbol = 'BTW';
88     decimals = 18;
89     owner = 0x0034a61e60BD3325C08E36Ac3b208E43fc53E5C2;
90     initialSupply = 16000000 * 10 ** uint256(decimals);
91     totalSupply_ = initialSupply;
92     balances[owner] = initialSupply;
93     emit Transfer(0x0, owner, initialSupply);
94   }
95 }