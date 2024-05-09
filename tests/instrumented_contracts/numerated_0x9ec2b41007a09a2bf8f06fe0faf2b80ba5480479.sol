1 pragma solidity ^0.4.23;
2 
3 contract TokenRequestStub{
4     function balanceOf(address _owner) public view returns (uint256 balance);
5 }
6 
7 contract TokenReclaim{
8     TokenRequestStub tokenAddress;
9     mapping (address=>string) internal _ethToPubKey;
10     event AccountRegister (address ethAccount, string pubKey, uint holding);
11 
12     constructor() public{
13         tokenAddress = TokenRequestStub(0x3833ddA0AEB6947b98cE454d89366cBA8Cc55528);
14     }
15 
16     function register(string pubKey) public{
17         require(bytes(pubKey).length <= 64 && bytes(pubKey).length >= 50 );
18         uint holding = tokenAddress.balanceOf(msg.sender);
19         _ethToPubKey[msg.sender] = pubKey;
20         emit AccountRegister(msg.sender, pubKey, holding);
21     }
22 
23     function keys(address addr) constant public returns (string){
24         return _ethToPubKey[addr];
25     }
26 }