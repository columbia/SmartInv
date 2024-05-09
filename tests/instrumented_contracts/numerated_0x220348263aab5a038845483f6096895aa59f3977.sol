1 pragma solidity ^0.4.11;
2 
3 contract token { function preallocate(address receiver, uint fullTokens, uint weiPrice) public;
4                 function transferOwnership(address _newOwner) public;
5                 function acceptOwnership() public;
6                 }
7 contract Airdrop {
8     token public tokenReward;
9     
10     function Airdrop(token _addressOfTokenUsedAsTransfer) public{
11          tokenReward = token(_addressOfTokenUsedAsTransfer);
12     }
13 
14    /* TransferToken function for send token to many accound
15         @param _to address array hold the receiver address
16         @param _value send token value 
17         @param weiPrice Price of a single full token in wei
18    */
19 
20     function TransferToken (address[] _to, uint _value, uint _weiPrice) public
21     {   for (uint i=0; i< _to.length; i++)
22         {
23         tokenReward.preallocate(_to[i], _value, _weiPrice);
24         }
25     }
26 
27     /* TransferOwner function for Transfer the owner ship to address
28         @param _owner address of owner
29     */
30 
31 
32     function TransferOwner (address _owner) public {
33         tokenReward.transferOwnership(_owner);
34     }
35 
36     /* 
37         acceptOwner function for accept owner ship of account
38     */
39 
40     function acceptOwner () public {
41         tokenReward.acceptOwnership();
42     }
43 
44     /* 
45         removeContract function for destroy the contract on network
46     */
47 
48     function removeContract() public
49         {
50             selfdestruct(msg.sender);
51             
52         }   
53 }