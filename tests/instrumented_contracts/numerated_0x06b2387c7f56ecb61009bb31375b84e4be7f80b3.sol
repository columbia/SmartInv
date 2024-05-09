1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract iPromo {
46     function massNotify(address[] _owners) public;
47     function transferOwnership(address newOwner) public;
48 }
49 
50 /**
51 * Distribute promo tokens parallel
52 *   negligible, +3k gas cost / tx
53 *   500 address ~ 1.7M gas
54 * author: thesved, viktor.tabori at etheal dot com
55 */
56 contract EthealPromoDistribute is Ownable {
57     mapping (address => bool) public admins;
58     iPromo public token;
59 
60     // constructor
61     constructor(address _promo) public {
62         token = iPromo(_promo);
63     }
64 
65     // set promo token
66     function setToken(address _promo) onlyOwner public {
67         token = iPromo(_promo);
68     }
69 
70     // transfer ownership of token
71     function passToken(address _promo) onlyOwner public {
72         require(_promo != address(0));
73         require(address(token) != address(0));
74 
75         token.transferOwnership(_promo);
76     }
77 
78     // set admins
79     function setAdmin(address[] _admins, bool _v) onlyOwner public {
80         for (uint256 i = 0; i<_admins.length; i++) {
81             admins[ _admins[i] ] = _v;
82         }
83     }
84 
85     // notify
86     function massNotify(address[] _owners) external {
87         require(admins[msg.sender] || msg.sender == owner);
88         token.massNotify(_owners);
89     }
90 }