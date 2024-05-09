1 /**
2  *  Coffee
3  *
4  *  Just a very simple example of deploying a contract at a vanity address
5  *  across several chains.
6  *
7  *  See: https://blog.ricmoo.com/contract-addresses-549074919ec8
8  *
9  */
10 
11 pragma solidity ^0.4.20;
12 
13 contract Coffee {
14 
15     address _owner;
16 
17     uint48 _mgCaffeine;
18     uint48 _count;
19 
20     function Coffee() {
21         _owner = msg.sender;
22     }
23 
24     /**
25      *   Allow the owner to change the account that controls this contract.
26      *
27      *   We may wish to use powerful computers that may be public or
28      *   semi-public to compute the private key we use to deploy the contract,
29      *   to a vanity adddress. So once deployed, we want to move it to a
30      *   cold-storage key.
31      */
32     function setOwner(address owner) {
33         require(msg.sender == _owner);
34         _owner = owner;
35     }
36 
37     /**
38      *   status()
39      *
40      *   Returns the number of drinks and amount of caffeine this contract
41      *   has been responsible for installing into the developer.
42      */
43     function status() public constant returns (uint48 count, uint48 mgCaffeine) {
44         count = _count;
45         mgCaffeine = _mgCaffeine;
46     }
47 
48     /**
49      *  withdraw(amount, count, mgCaffeine)
50      *
51      *  Withdraws funds from this contract to the owner, indicating how many drinks
52      *  and how much caffeine these funds will be used to install into the develoepr.
53      */
54     function withdraw(uint256 amount, uint8 count, uint16 mgCaffeine) public {
55         require(msg.sender == _owner);
56         _owner.transfer(amount);
57         _count += count;
58         _mgCaffeine += mgCaffeine;
59     }
60 
61     // Let this contract accept payments
62     function () public payable { }
63 }