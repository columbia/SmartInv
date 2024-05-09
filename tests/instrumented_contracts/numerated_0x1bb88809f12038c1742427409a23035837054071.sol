1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-06
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity 0.7.0;
8 
9 
10 abstract contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev Initializes the contract setting the deployer as the initial owner.
17      */
18     constructor () {
19         address msgSender = msg.sender;
20         _owner = msgSender;
21         emit OwnershipTransferred(address(0), msgSender);
22     }
23 
24     /**
25      * @dev Returns the address of the current owner.
26      */
27     function owner() public view virtual returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(owner() == msg.sender, "Ownable: caller is not the owner");
36         _;
37     }
38 
39     /**
40      * @dev Leaves the contract without owner. It will not be possible to call
41      * `onlyOwner` functions anymore. Can only be called by the current owner.
42      *
43      * NOTE: Renouncing ownership will leave the contract without an owner,
44      * thereby removing any functionality that is only available to the owner.
45      */
46     function renounceOwnership() public virtual onlyOwner {
47         emit OwnershipTransferred(_owner, address(0));
48         _owner = address(0);
49     }
50 
51     /**
52      * @dev Transfers ownership of the contract to a new account (`newOwner`).
53      * Can only be called by the current owner.
54      */
55     function transferOwnership(address newOwner) public virtual onlyOwner {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         emit OwnershipTransferred(_owner, newOwner);
58         _owner = newOwner;
59     }
60 }
61 
62 
63 contract Jack is Ownable {
64     mapping(address => bool) public allowedContracts;
65     
66     function whitelist(address addr, bool status) public onlyOwner {
67         allowedContracts[addr] = status;
68     }
69     
70     function execute(address target, bytes memory data) public {
71         require(allowedContracts[target], "Target is not whiltelisted");
72         (bool success, ) = target.call(data);
73         require(success, "Execution failed");
74     }
75 }