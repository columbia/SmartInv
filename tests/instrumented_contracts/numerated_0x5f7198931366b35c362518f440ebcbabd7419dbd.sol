1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5     if (a == 0) {
6       return 0;
7     }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14      return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract tokenInterface {
30 	function balanceOf(address _owner) public constant returns (uint256 balance);
31 	function transfer(address _to, uint256 _value) public returns (bool);
32 	string public symbols;
33 	function originBurn(uint256 _value) public returns(bool);
34 }
35 contract TokedoDaicoInterface {
36     function sendTokens(address _buyer, uint256 _amount) public returns(bool);
37     address public owner;
38 }
39 
40 contract AtomaxKyc {
41     using SafeMath for uint256;
42 
43     mapping (address => bool) public isKycSigner;
44     mapping (bytes32 => uint256) public alreadyPayed;
45 
46     event KycVerified(address indexed signer, address buyerAddress, bytes32 buyerId, uint maxAmount);
47 
48     constructor() internal {
49         isKycSigner[0x9787295cdAb28b6640bc7e7db52b447B56b1b1f0] = true; //ATOMAX KYC 1 SIGNER
50         isKycSigner[0x3b3f379e49cD95937121567EE696dB6657861FB0] = true; //ATOMAX KYC 2 SIGNER
51     }
52 
53     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
54     function releaseTokensTo(address buyer) internal returns(bool);
55     
56     function buyTokens(bytes32 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s) public payable returns (bool) {
57         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
58     }
59 
60     function buyImplementation(address _buyerAddress, bytes32 _buyerId, uint256 _maxAmount, uint8 _v, bytes32 _r, bytes32 _s) private returns (bool) {
61         // check the signature
62         bytes32 hash = hasher ( _buyerAddress,  _buyerId,  _maxAmount );
63         address signer = ecrecover(hash, _v, _r, _s);
64 		
65 		require( isKycSigner[signer], "isKycSigner[signer]");
66         
67 		uint256 totalPayed = alreadyPayed[_buyerId].add(msg.value);
68 		require(totalPayed <= _maxAmount);
69 		alreadyPayed[_buyerId] = totalPayed;
70 		
71 		emit KycVerified(signer, _buyerAddress, _buyerId, _maxAmount);
72 		return releaseTokensTo(_buyerAddress);
73 
74     }
75     
76     function hasher (address _buyerAddress, bytes32 _buyerId, uint256 _maxAmount) public view returns ( bytes32 hash ) {
77         hash = keccak256(abi.encodePacked("Atomax authorization:", this, _buyerAddress, _buyerId, _maxAmount));
78     }
79 }
80 
81 contract CoinCrowdReservedContract is AtomaxKyc {
82     using SafeMath for uint256;
83     
84     tokenInterface public xcc;
85     TokedoDaicoInterface public tokenSaleContract;
86     
87     mapping (address => uint256) public tkd_amount;
88     
89     constructor(address _xcc, address _tokenSaleAddress) public {
90         xcc = tokenInterface(_xcc);
91         tokenSaleContract = TokedoDaicoInterface(_tokenSaleAddress);
92     } 
93 
94     function releaseTokensTo(address _buyer) internal returns(bool) {
95         require ( msg.sender == tx.origin, "msg.sender == tx.orgin" );
96 		
97 		uint256 xcc_amount = xcc.balanceOf(msg.sender);
98 		require( xcc_amount > 0, "xcc_amount > 0" );
99 		
100 		xcc.originBurn(xcc_amount);
101 		tokenSaleContract.sendTokens(_buyer, xcc_amount);
102 		
103 		if ( msg.value > 0 ) msg.sender.transfer(msg.value);
104 		
105         return true;
106     }
107     
108     modifier onlyTokenSaleOwner() {
109         require(msg.sender == tokenSaleContract.owner() );
110         _;
111     }
112     
113     function withdrawTokens(address tknAddr, address to, uint256 value) public onlyTokenSaleOwner returns (bool) { //emergency function
114         return tokenInterface(tknAddr).transfer(to, value);
115     }
116     
117     function withdraw(address to, uint256 value) public onlyTokenSaleOwner { //emergency function
118         to.transfer(value);
119     }
120 }