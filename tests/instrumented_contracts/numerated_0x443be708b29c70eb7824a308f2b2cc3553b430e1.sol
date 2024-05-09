1 pragma solidity ^0.4.18;
2 /*
3   ASTRCoin ICO - Airdrop code
4  */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {  //was constant
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 
37 
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address newOwner) onlyOwner public {
54     require(newOwner != address(0));
55     OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 contract ERC20 { 
62     function transfer(address receiver, uint amount) public ;
63     function transferFrom(address sender, address receiver, uint amount) public returns(bool success); // do token.approve on the ICO contract
64     function balanceOf(address _owner) constant public returns (uint256 balance);
65 }
66 
67 /**
68  * Airdrop for ASTRCoin
69  */
70 contract ASTRDrop is Ownable {
71   ERC20 public token;  // using the ASTRCoin token - will set an address
72   address public ownerAddress;  // deploy owner
73   uint8 internal decimals             = 4; // 4 decimal places should be enough in general
74   uint256 internal decimalsConversion = 10 ** uint256(decimals);
75   uint public   AIRDROP_AMOUNT        = 10 * decimalsConversion;
76 
77   function multisend(address[] dests) onlyOwner public returns (uint256) {
78 
79     ownerAddress    = ERC20(0x3EFAe2e152F62F5cc12cc0794b816d22d416a721); // 
80     token           = ERC20(0x80E7a4d750aDe616Da896C49049B7EdE9e04C191); //  
81 
82       uint256 i = 0;
83       while (i < dests.length) { // probably want to keep this to only 20 or 30 addresses at a time
84         token.transferFrom(ownerAddress, dests[i], AIRDROP_AMOUNT);
85          i += 1;
86       }
87       return(i);
88     }
89 
90   // Change the airdrop rate
91   function setAirdropAmount(uint256 _astrAirdrop) onlyOwner public {
92     if( _astrAirdrop > 0 ) {
93         AIRDROP_AMOUNT = _astrAirdrop * decimalsConversion;
94     }
95   }
96 
97 
98   // reset the rate to the default
99   function resetAirdropAmount() onlyOwner public {
100      AIRDROP_AMOUNT = 10 * decimalsConversion;
101   }
102 }