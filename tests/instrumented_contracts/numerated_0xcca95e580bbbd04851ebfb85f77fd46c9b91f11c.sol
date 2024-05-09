1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4   event Transfer(address indexed from, address indexed to, uint value);
5   function balanceOf( address who ) public constant returns (uint value);
6   function transfer( address to, uint value) public returns (bool ok);
7   function approve( address to, uint value) public returns (bool ok);
8   function transferFrom(address from, address to, uint value) public returns (bool ok);
9 }
10 
11 contract Owned {
12     address public owner;
13 
14     function Owned() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner public {
24         owner = newOwner;
25     }
26 }
27 
28 contract TerraformReserve is Owned {
29 
30   /* Storing a balance for each user */
31   mapping (address => uint256) public lockedBalance;
32   
33   /* Store the total sum locked */
34   uint public totalLocked;
35   
36   /* Reference to the token */
37   ERC20 public manaToken;
38   
39   /* Contract that will assign the LAND and burn/return tokens */
40   address public landClaim;
41   
42   /* Prevent the token from accepting deposits */
43   bool public acceptingDeposits;
44 
45   event LockedBalance(address user, uint mana);
46   event LandClaimContractSet(address target);
47   event LandClaimExecuted(address user, uint value, bytes data);
48   event AcceptingDepositsChanged(bool _acceptingDeposits);
49 
50   function TerraformReserve(address _token) {
51     require(_token != 0);
52     manaToken = ERC20(_token);
53     acceptingDeposits = true;
54   }
55 
56   /**
57    * Lock MANA into the contract.
58    * This contract does not have another way to take the tokens out other than
59    * through the target contract.
60    */
61   function lockMana(address _from, uint256 mana) public {
62     require(acceptingDeposits);
63     require(mana >= 1000 * 1e18);
64     require(manaToken.transferFrom(_from, this, mana));
65 
66     lockedBalance[_from] += mana; 
67     totalLocked += mana;
68     LockedBalance(_from, mana);
69   }
70   
71   /**
72    * Allows the owner of the contract to pause acceptingDeposits
73    */
74   function changeContractState(bool _acceptingDeposits) public onlyOwner {
75     acceptingDeposits = _acceptingDeposits;
76     AcceptingDepositsChanged(acceptingDeposits);
77   }
78   
79   /**
80    * Set the contract that can move the staked MANA.
81    * Calls the `approve` function of the ERC20 token with the total amount.
82    */
83   function setTargetContract(address target) public onlyOwner {
84     landClaim = target;
85     manaToken.approve(landClaim, totalLocked);
86     LandClaimContractSet(target);
87   }
88 
89   /**
90    * Prevent payments to the contract
91    */
92   function () public payable {
93     revert();
94   }
95 }