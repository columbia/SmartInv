1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract GiftEth {
41 
42   event RecipientChanged(address indexed _oldRecipient, address indexed _newRecipient);
43 
44   address public gifter;
45   address public recipient;
46   uint256 public lockTs;
47   string public giftMessage;
48 
49   function GiftEth(address _gifter, address _recipient, uint256 _lockTs, string _giftMessage) payable public {
50     gifter = _gifter;
51     recipient = _recipient;
52     lockTs = _lockTs;
53     giftMessage = _giftMessage;
54   }
55 
56   function withdraw() public {
57     require(msg.sender == recipient);
58     require(now >= lockTs);
59     msg.sender.transfer(this.balance);
60   }
61 
62   function changeRecipient(address _newRecipient) public {
63     require(msg.sender == recipient);
64     RecipientChanged(recipient, _newRecipient);
65     recipient = _newRecipient;
66   }
67 
68 }
69 
70 contract GiftEthFactory is Ownable {
71 
72   event GiftGenerated(address indexed _gifter, address indexed _recipient, address indexed _gift, uint256 _amount, uint256 _lockTs, string _giftMessage);
73   event Frozen(bool _frozen);
74 
75   bool public frozen;
76 
77   modifier notFrozen {
78     require(!frozen);
79     _;
80   }
81 
82   function setFrozen(bool _frozen) public onlyOwner {
83     frozen = _frozen;
84     Frozen(frozen);
85   }
86 
87   function giftEth(address _recipient, uint256 _lockTs, string _giftMessage) payable public notFrozen {
88     GiftEth gift = (new GiftEth).value(msg.value)(msg.sender, _recipient, _lockTs, _giftMessage);
89     GiftGenerated(msg.sender, _recipient, address(gift), msg.value, _lockTs, _giftMessage);
90   }
91 
92 }