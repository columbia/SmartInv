1 pragma solidity ^0.4.19;
2 
3 /* This is a simple contract
4    to let people write a phrase
5    or SHA256 hash to the blockchain.
6    Optional signatures can be purchased by 0.001 ETH,
7    if someone finds it useful for an application.
8 */
9 contract logPhrase {
10 
11     address owner = msg.sender;
12 
13    //unique 16 bytes signatures and corresponding addresses
14     mapping (bytes16 => address) signatures;
15 
16    //cost to by a signature (and get your address into the mapping)
17     uint128 constant minimumPayment = 0.001 ether;
18 
19     function logPhrase() payable public {
20         
21     }
22 
23     function () payable public {
24         //Donations are welcome. They go to the owner.
25         address contractAddr = this;
26         owner.transfer(contractAddr.balance);
27     }
28 
29    //The signed logs are indexed
30     event Spoke(bytes16 indexed signature, string phrase);
31 
32    //unsigned log
33     function logUnsigned(bytes32 phrase) public
34     {
35         log0(phrase);
36     }
37 
38    //signed log
39     function logSigned(string phrase, bytes16 sign) public
40     {
41         //can only be called by the owner of the signature
42         require (signatures[sign]==msg.sender); //check valid address
43         Spoke(sign, phrase);
44     }
45 
46    //buy a 16 bytes signature for 0.001 ETH
47     function buySignature(bytes16 sign) payable public
48     {
49         //signatures are unique
50         require(msg.value > minimumPayment && signatures[sign]==0);
51         signatures[sign]=msg.sender; //we got a new signer
52         address contractAddr = this;
53         owner.transfer(contractAddr.balance); //thanks
54     }
55 
56    //query whois the owner address of the signature    
57     function getAddress(bytes16 sign) public returns (address) {
58         return signatures[sign];
59     }
60     
61 
62 }