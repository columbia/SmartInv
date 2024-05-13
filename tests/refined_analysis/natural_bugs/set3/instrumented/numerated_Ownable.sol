1 pragma solidity ^0.5.0;
2 
3 import "../GSN/Context.sol";
4 /**
5  * @dev Contract module which provides a basic access control mechanism, where
6  * there is an account (an owner) that can be granted exclusive access to
7  * specific functions.
8  *
9  * This module is used through inheritance. It will make available the modifier
10  * `onlyOwner`, which can be applied to your functions to restrict their use to
11  * the owner.
12  */
13 contract Ownable is Context {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev Initializes the contract setting the deployer as the initial owner.
20      */
21     constructor () internal {
22         address msgSender = _msgSender();
23         _owner = msgSender;
24         emit OwnershipTransferred(address(0), msgSender);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return _msgSender() == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public  onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
