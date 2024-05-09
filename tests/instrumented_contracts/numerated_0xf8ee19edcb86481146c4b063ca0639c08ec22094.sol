1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-16
3 */
4 
5 pragma solidity 0.6.4;
6 /**
7  * @title Manage the owner for the BulkSender contract.
8  */
9 contract Ownable {
10     address private _owner;
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12     constructor() public {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(this), _owner);
15     }
16     /**
17      * Returns the address of the current owner.
18      */
19     function owner() public view returns (address) {
20         return _owner;
21     }
22     /**
23      * Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == _owner, "Ownable: the caller is not the owner");
27         _;
28     }
29     /**
30      * Sets the new address as the owner.
31      */
32     function transferOwnership(address newOwner) onlyOwner public {
33         require(newOwner != address(0), "Ownable: the new owner is the zero address");
34         emit OwnershipTransferred(_owner, newOwner);
35         _owner = newOwner;
36     }
37 }
38 /**
39  * @title Sending bulk transactions from the whitelisted wallets.
40  */
41 contract BulkSender is Ownable {
42     mapping(address => bool) whitelist;
43     /**
44      * Throws if called by any account other than the whitelisted address.
45      */
46     modifier onlyWhiteListed() {
47         require(whitelist[msg.sender], "Whitelist: the caller is not whitelisted");
48         _;
49     }
50     /**
51      * Approves the address as the whitelisted address.
52      */
53     function approve(address addr) onlyOwner external {
54         whitelist[addr] = true;
55     }
56     /**
57      * Removes the whitelisted address from the whitelist.
58      */
59     function remove(address addr) onlyOwner external {
60         whitelist[addr] = false;
61     }
62     /**
63      * Returns true if the address is the whitelisted address.
64      */
65     function isWhiteListed(address addr) public view returns (bool) {
66         return whitelist[addr];
67     }
68     /**
69      * @dev Gets the list of addresses and the list of amounts to make bulk transactions.
70      * @param addresses - address[]
71      * @param amounts - uint256[]
72      */
73     function distribute(address[] calldata addresses, uint256[] calldata amounts) onlyWhiteListed external payable  {
74         require(addresses.length > 0, "BulkSender: the length of addresses should be greater than zero");
75         require(amounts.length == addresses.length, "BulkSender: the length of addresses is not equal the length of amounts");
76         for (uint256 i; i < addresses.length; i++) {
77             uint256 value = amounts[i];
78             require(value > 0, "BulkSender: the value should be greater then zero");
79             address payable _to = address(uint160(addresses[i]));
80             _to.transfer(value);
81         }
82     }
83     /**
84      * @dev This contract shouldn't accept payments.
85      */
86     receive() external payable {
87         revert("This contract shouldn't accept payments.");
88     }
89 }