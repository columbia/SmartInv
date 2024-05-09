1 pragma solidity ^0.4.19;
2 contract SlavenSS {
3     
4     address public owner;
5     address public slavenAdress;
6     
7     bytes32 private targetHash = 0xa8e19a7b59881fcc24f7eb078a8e730ef446b05a404d078341862359ba05ade6; 
8     
9     modifier onlySlaven() {
10         require (msg.sender == slavenAdress);
11         _;
12     }
13     
14     modifier onlyOwner() {
15         require (msg.sender == owner);
16         _;
17     }
18     
19     function SlavenSS() public {
20         owner = msg.sender;
21     }
22     
23     function changeHash(bytes32 newTargetHash) public onlyOwner {
24         targetHash = newTargetHash;
25     }
26     
27     function registerAsSlaven(string passphrase) public {
28         require (keccak256(passphrase) == targetHash);
29         slavenAdress = msg.sender;
30     }
31     
32     function deposit() payable external {
33         //deposits money to Slaven SS fund
34     }
35     
36     function withdraw() onlySlaven external {
37         require (slavenAdress != address(0));
38         require(slavenAdress.send(this.balance));
39     }
40 }