1 pragma solidity ^0.4.19;
2 // Digital Signature Contract
3 // This contract has been created by Gaurang Torvekar, the co-founder and CTO of Attores, a Singaporean company which is creating a SaaS platform for Smart Contracts
4 
5 contract AttoresDigitalCertificates{
6    uint public amountInContract;
7     
8     mapping (address => bool) public ownerList;
9     
10     struct SignatureDetails{
11         bytes32 email;
12         uint timeStamp;
13     }
14     
15     mapping (bytes32 => SignatureDetails) public hashList;
16     
17     uint public constant WEI_PER_ETHER = 1000000000000000000;
18     
19     function AttoresDigitalCertificates (address _owner){
20        ownerList[_owner] = true;
21        amountInContract += msg.value;
22    }
23    
24    modifier ifOwner() {
25        require(ownerList[msg.sender]);
26        _;
27    }
28    
29    function addOwner(address someone) ifOwner {
30        ownerList[someone] = true;
31    }
32    
33    function removeOwner(address someone) ifOwner {
34        ownerList[someone] = false;
35    }
36    
37    function certificate(bytes32 email, bytes32 hash) ifOwner{
38        hashList[hash] = SignatureDetails({
39            email: email,
40            timeStamp: now
41        });
42    }
43 
44 }