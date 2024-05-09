1 //
2 // compiler: 0.4.21+commit.dfe3193c.Emscripten.clang
3 //
4 pragma solidity ^0.4.21;
5 
6 contract owned {
7   address public owner;
8   function owned() public { owner = msg.sender; }
9 
10   modifier onlyOwner {
11     if (msg.sender != owner) { revert(); }
12     _;
13   }
14 
15   function changeOwner( address newown ) public onlyOwner { owner = newown; }
16   function closedown() public onlyOwner { selfdestruct( owner ); }
17 }
18 
19 // token sold by this contract must be ERC20-compliant
20 interface ERC20 {
21   function transfer(address to, uint256 value) external;
22   function balanceOf( address owner ) external constant returns (uint);
23 }
24 
25 contract ICO is owned {
26 
27   ERC20 public tokenSC;
28   address      treasury;
29   uint public  start;     // seconds since Jan 1 1970 GMT
30   uint public  duration;  // seconds
31   uint public  tokpereth; // rate, price
32   uint public  minfinney; // enforce minimum spend to buy tokens
33 
34   function ICO( address _erc20,
35                 address _treasury,
36                 uint _startSec,
37                 uint _durationSec,
38                 uint _tokpereth ) public
39   {
40     require( isContract(_erc20) );
41     require( _tokpereth > 0 );
42 
43     if (_treasury != address(0)) require( isContract(_treasury) );
44 
45     tokenSC = ERC20( _erc20 );
46     treasury = _treasury;
47     start = _startSec;
48     duration = _durationSec;
49     tokpereth = _tokpereth;
50     minfinney = 25;
51   }
52 
53   function setToken( address erc ) public onlyOwner { tokenSC = ERC20(erc); }
54   function setTreasury( address treas ) public onlyOwner { treasury = treas; }
55   function setStart( uint newstart ) public onlyOwner { start = newstart; }
56   function setDuration( uint dur ) public onlyOwner { duration = dur; }
57   function setRate( uint rate ) public onlyOwner { tokpereth = rate; }
58   function setMinimum( uint newmin ) public onlyOwner { minfinney = newmin; }
59 
60   function() public payable {
61     require( msg.value >= minfinney );
62     if (now < start || now > (start + duration)) revert();
63 
64     // quantity =
65     //   amountinwei * tokpereth/weipereth * (bonus+100)/100
66     // = amountinwei * tokpereth/1e18 * (bonus+100)/100
67     // = msg.value * tokpereth/1e20 * (bonus+100)
68 
69     // NOTE: this calculation does not take decimals into account, because
70     //       in MOB case there aren't any (decimals == 0)
71     uint qty =
72       multiply( divide( multiply( msg.value,
73                                   tokpereth ),
74                         1e20),
75                 (bonus() + 100) );
76 
77     if (qty > tokenSC.balanceOf(address(this)) || qty < 1)
78       revert();
79 
80     tokenSC.transfer( msg.sender, qty );
81 
82     if (treasury != address(0)) treasury.transfer( msg.value );
83   }
84 
85   // unsold tokens can be claimed by owner after sale ends
86   function claimUnsold() public onlyOwner {
87     if ( now < (start + duration) ) revert();
88 
89     tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );
90   }
91 
92   function withdraw( uint amount ) public onlyOwner returns (bool) {
93     require ( treasury == address(0) && amount <= address(this).balance );
94     return owner.send( amount );
95   }
96 
97   // edited : no bonus scheme this ICO
98   function bonus() pure private returns(uint) { return 0; }
99 
100   function isContract( address _a ) constant private returns (bool) {
101     uint ecs;
102     assembly { ecs := extcodesize(_a) }
103     return ecs > 0;
104   }
105 
106   // ref: github.com/OpenZeppelin/zeppelin-solidity/
107   //      blob/master/contracts/math/SafeMath.sol
108   function multiply(uint256 a, uint256 b) pure private returns (uint256) {
109     uint256 c = a * b;
110     assert(a == 0 || c / a == b);
111     return c;
112   }
113 
114   function divide(uint256 a, uint256 b) pure private returns (uint256) {
115     return a / b;
116   }
117 }