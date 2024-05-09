1 pragma solidity ^0.4.18;
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
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 contract Claimable is Ownable {
39   address public pendingOwner;
40 
41   /**
42    * @dev Modifier throws if called by any account other than the pendingOwner.
43    */
44   modifier onlyPendingOwner() {
45     require(msg.sender == pendingOwner);
46     _;
47   }
48 
49   /**
50    * @dev Allows the current owner to set the pendingOwner address.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) onlyOwner public {
54     pendingOwner = newOwner;
55   }
56 
57   /**
58    * @dev Allows the pendingOwner address to finalize the transfer.
59    */
60   function claimOwnership() onlyPendingOwner public {
61     OwnershipTransferred(owner, pendingOwner);
62     owner = pendingOwner;
63     pendingOwner = address(0);
64   }
65 }
66 
67 contract AddressList is Claimable {
68     string public name;
69     mapping (address => bool) public onList;
70 
71     function AddressList(string _name, bool nullValue) public {
72         name = _name;
73         onList[0x0] = nullValue;
74     }
75     event ChangeWhiteList(address indexed to, bool onList);
76 
77     // Set whether _to is on the list or not. Whether 0x0 is on the list
78     // or not cannot be set here - it is set once and for all by the constructor.
79     function changeList(address _to, bool _onList) onlyOwner public {
80         require(_to != 0x0);
81         if (onList[_to] != _onList) {
82             onList[_to] = _onList;
83             ChangeWhiteList(_to, _onList);
84         }
85     }
86 }