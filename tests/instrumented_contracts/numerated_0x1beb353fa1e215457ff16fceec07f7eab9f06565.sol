1 pragma solidity ^0.4.25;
2 
3 contract EscrowWallet {
4 
5   event Requested(address indexed _receiver, uint256 _amount, uint256 balance);
6   event Approved(address indexed _receiver, uint256 _amount, uint256 balance);
7   event Declined(address indexed _whom, address indexed _receiver);
8   event Received(address indexed _payer, uint256 _amount);
9 
10   mapping (address => uint256) private requested;
11 
12   address private escrow;
13   address private owner;
14 
15   constructor(address _escrow) public payable {
16       escrow = _escrow;
17       owner  = msg.sender;
18   }
19 
20   function () external payable {
21     emit Received(msg.sender, msg.value);
22   }
23 
24   function Request(address _receiver, uint256 _amount) public {
25     require(msg.sender == owner);
26     require(_receiver != address(0) && _receiver != address(this));
27     require(_amount > 0);
28     require(requested[_receiver] == 0);
29 
30     requested[_receiver] = _amount;
31     emit Requested(_receiver, _amount, address(this).balance);
32   }
33 
34   function Approve(address _receiver, uint256 _amount) public {
35     require(msg.sender == escrow);
36     require(_amount > 0);
37     require(requested[_receiver] == _amount);
38 
39     requested[_receiver] = 0;
40     _receiver.transfer(_amount);
41     emit Approved(_receiver, _amount, address(this).balance);
42   }
43 
44   function Decline(address _receiver) public {
45     require(msg.sender == escrow || msg.sender == owner);
46 
47     requested[_receiver] = 0;
48     emit Declined(msg.sender, _receiver);
49   }
50 }