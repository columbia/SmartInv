1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    */
11   function Ownable() public {
12     owner = msg.sender;
13   }
14 
15   /**
16    * @dev Throws if called by any account other than the owner.
17    */
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23   /**
24    * @dev Allows the current owner to transfer control of the contract to a newOwner.
25    */
26   function transferOwnership(address newOwner) public onlyOwner {
27     require(newOwner != address(0));
28     OwnershipTransferred(owner, newOwner);
29     owner = newOwner;
30   }
31 }
32 
33 contract Claimable is Ownable {
34   address public pendingOwner;
35 
36   /**
37    * @dev Modifier throws if called by any account other than the pendingOwner.
38    */
39   modifier onlyPendingOwner() {
40     require(msg.sender == pendingOwner);
41     _;
42   }
43 
44   /**
45    * @dev Allows the current owner to set the pendingOwner address.
46    */
47   function transferOwnership(address newOwner) public onlyOwner{
48     pendingOwner = newOwner;
49   }
50 
51   /**
52    * @dev Allows the pendingOwner address to finalize the transfer.
53    */
54   function claimOwnership() onlyPendingOwner public {
55     OwnershipTransferred(owner, pendingOwner);
56     owner = pendingOwner;
57     pendingOwner = address(0);
58   }
59 }
60 
61 contract AddressList is Claimable {
62     string public name;
63     mapping (address => bool) public onList;
64 
65     function AddressList(string _name, bool nullValue) public {
66         name = _name;
67         onList[0x0] = nullValue;
68     }
69     event ChangeWhiteList(address indexed to, bool onList);
70 
71     // Set whether _to is on the list or not. Whether 0x0 is on the list
72     // or not cannot be set here - it is set once and for all by the constructor.
73     function changeList(address _to, bool _onList) onlyOwner public {
74         require(_to != 0x0);
75         if (onList[_to] != _onList) {
76             onList[_to] = _onList;
77             ChangeWhiteList(_to, _onList);
78         }
79     }
80 }