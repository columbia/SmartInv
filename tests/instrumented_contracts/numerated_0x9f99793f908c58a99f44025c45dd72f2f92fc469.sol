1 //
2 // compiler: solcjs -o ./build/contracts --optimize --abi --bin <this file>
3 //  version: 0.4.19+commit.c4cbbb05.Emscripten.clang
4 //
5 pragma solidity ^0.4.19;
6 
7 contract owned {
8   address public owner;
9   function owned() public { owner = msg.sender; }
10   function changeOwner( address newowner ) public onlyOwner {owner = newowner;}
11   function closedown() public onlyOwner {selfdestruct(owner);}
12   modifier onlyOwner {
13     if (msg.sender != owner) { revert(); }
14     _;
15   }
16 }
17 
18 // token should be ERC20-compliant and implement these functions
19 interface ERC20 {
20   function transfer(address to, uint256 value) public;
21   function balanceOf( address owner ) public constant returns (uint);
22 }
23 
24 contract RTKICO is owned {
25 
26   ERC20   public tokenSC;   // token this ICO is selling
27   address        treasury;  // [optional] where to direct incoming Ether
28   uint    public start;     // seconds since Jan 1 1970 GMT
29   uint    public duration;  // seconds
30   uint    public tokpereth; // price NOTE: attention to decimals on setup
31 
32   function RTKICO( address _erc20,
33                    address _treasury,
34                    uint    _startSec,
35                    uint    _durationSec,
36                    uint    _tokpereth ) public {
37 
38     require( isContract(_erc20) );
39     require( _tokpereth > 0 );
40 
41     if (_treasury != address(0))
42       require( isContract(_treasury) );
43 
44     tokenSC = ERC20( _erc20 );
45     treasury = _treasury;
46     start = _startSec;
47     duration = _durationSec;
48     tokpereth = _tokpereth;
49   }
50 
51   function setTreasury( address treas ) public onlyOwner { treasury = treas; }
52   function setStart( uint newstart ) public onlyOwner { start = newstart; }
53   function setRate( uint rate ) public onlyOwner { tokpereth = rate; }
54   function setDuration( uint dur ) public onlyOwner { duration = dur; }
55 
56   function() public payable {
57     if (now < start || now > (start + duration))
58       revert();
59 
60     // Calculation:
61     //   amountinwei * tokpereth/weipereth * (bonus+100)/100
62     // = amountinwei * tokpereth/1e18 * (bonus+100)/100
63     // = msg.value * tokpereth/1e20 * (bonus+100)
64     uint qty =
65       multiply( divide( multiply( msg.value, tokpereth ),
66                         1e20 ),
67                 (bonus()+100) );
68 
69     if (qty > tokenSC.balanceOf(address(this)) || qty < 1)
70       revert();
71 
72     tokenSC.transfer( msg.sender, qty );
73 
74     if (treasury != address(0)) treasury.transfer( msg.value );
75   }
76 
77   // unsold tokens can be claimed by owner after sale ends
78   function claimUnsold() public onlyOwner {
79     if ( now < (start + duration) )
80       revert();
81 
82     tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );
83   }
84 
85   function withdraw( uint amount ) public onlyOwner returns (bool) {
86     require (amount <= this.balance);
87     return owner.send( amount );
88   }
89 
90   function bonus() internal constant returns(uint) {
91     uint elapsed = now - start;
92 
93     if (elapsed < 1 weeks) return 20;
94     if (elapsed < 2 weeks) return 15;
95     if (elapsed < 4 weeks) return 10;
96     return 0;
97   }
98 
99   function isContract( address _a ) constant private returns (bool) {
100     uint ecs;
101     assembly { ecs := extcodesize(_a) }
102     return ecs > 0;
103   }
104 
105   // ref: github.com/OpenZeppelin/zeppelin-solidity/
106   //      blob/master/contracts/math/SafeMath.sol
107   function multiply(uint256 a, uint256 b) pure private returns (uint256) {
108     uint256 c = a * b;
109     assert(a == 0 || c / a == b);
110     return c;
111   }
112 
113   function divide(uint256 a, uint256 b) pure private returns (uint256) {
114     return a / b;
115   }
116 }