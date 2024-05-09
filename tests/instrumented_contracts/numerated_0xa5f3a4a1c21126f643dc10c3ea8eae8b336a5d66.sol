1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  * @dev Based on https://github.com/OpenZeppelin/zeppelin-soliditysettable
9  */
10 contract Ownable {
11     address public owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     modifier onlyOwner() {
16         require(msg.sender == owner, "Can only be called by the owner");
17         _;
18     }
19 
20     modifier onlyValidAddress(address addr) {
21         require(addr != address(0), "Address cannot be zero");
22         _;
23     }
24 
25     /**
26      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
27      * account.
28      */
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner)
38         public
39         onlyOwner
40         onlyValidAddress(newOwner)
41     {
42         emit OwnershipTransferred(owner, newOwner);
43 
44         owner = newOwner;
45     }
46 }
47 
48 
49 /**
50  * @title Truffle Migrations contract
51  * @dev It violates standard naming convention for compatibility with Truffle suite
52  * @dev It extends standard implementation with changeable owner.
53  */
54 contract Migrations is Ownable {
55     // solhint-disable-next-line var-name-mixedcase
56     uint256 public last_completed_migration;
57 
58     function setCompleted(uint256 completed) public onlyOwner {
59         last_completed_migration = completed;
60     }
61 
62     // solhint-disable-next-line func-param-name-mixedcase
63     function upgrade(address new_address) public onlyOwner {
64         Migrations upgraded = Migrations(new_address);
65         upgraded.setCompleted(last_completed_migration);
66     }
67 }