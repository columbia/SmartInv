1 pragma solidity ^0.4.17;
2 
3 contract GiftEth {
4 
5   event RecipientChanged(address indexed _oldRecipient, address indexed _newRecipient);
6 
7   address public gifter;
8   address public recipient;
9   uint256 public lockTs;
10   string public giftMessage;
11 
12   function GiftEth(address _gifter, address _recipient, uint256 _lockTs, string _giftMessage) payable public {
13     gifter = _gifter;
14     recipient = _recipient;
15     lockTs = _lockTs;
16     giftMessage = _giftMessage;
17   }
18 
19   function withdraw() public {
20     require(msg.sender == recipient);
21     require(now >= lockTs);
22     msg.sender.transfer(this.balance);
23   }
24 
25   function changeRecipient(address _newRecipient) public {
26     require(msg.sender == recipient);
27     RecipientChanged(recipient, _newRecipient);
28     recipient = _newRecipient;
29   }
30 
31 }