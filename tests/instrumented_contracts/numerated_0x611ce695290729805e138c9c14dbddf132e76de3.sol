1 pragma solidity ^0.4.13;
2 
3 contract Ownable 
4 
5 {
6 
7   address public owner;
8 
9  
10 
11   constructor(address _owner) public 
12 
13   {
14 
15     owner = _owner;
16 
17   }
18 
19  
20 
21   modifier onlyOwner() 
22 
23   {
24 
25     require(msg.sender == owner);
26 
27     _;
28 
29   }
30 
31  
32 
33   function transferOwnership(address newOwner) onlyOwner 
34 
35   {
36 
37     require(newOwner != address(0));      
38 
39     owner = newOwner;
40 
41   }
42 
43 }
44 
45 contract MarketData is Ownable {	 
46 
47 	struct CoinExchangeRatio {
48 
49 		uint256 num;
50 
51 		uint256 denom;
52 
53 	}
54 
55 	
56 
57 	mapping (address => mapping (address => CoinExchangeRatio)) public tokenExchangeRatio;	
58 
59 
60 
61 	constructor (address _owner) public Ownable(_owner) {
62 
63 	}
64 
65 
66 
67 	function setTokenExchangeRatio(address[] _tokenNum, address[] _tokenDenom, uint256[] _num, uint256[] _denom) public onlyOwner returns (bool ok) {
68 
69 		for(uint256 i= 0; i< _tokenNum.length; i++) {
70 
71 			if(_num[i]!= 0&& _denom[i]!= 0) {
72 
73 				tokenExchangeRatio[_tokenNum[i]][_tokenDenom[i]].num= _num[i];
74 
75 				tokenExchangeRatio[_tokenNum[i]][_tokenDenom[i]].denom= _denom[i];
76 
77 			}
78 
79 			else
80 
81 				return false;
82 
83 		}
84 
85 
86 
87 		return true;
88 
89 	}
90 
91 
92 
93 	function getTokenExchangeRatio(address _tokenNum, address _tokenDenom) public returns (uint256 num, uint256 denom) {
94 
95 		require(tokenExchangeRatio[_tokenNum][_tokenDenom].num > 0);
96 
97 		return (tokenExchangeRatio[_tokenNum][_tokenDenom].num, tokenExchangeRatio[_tokenNum][_tokenDenom].denom);
98 
99 	}
100 
101 }