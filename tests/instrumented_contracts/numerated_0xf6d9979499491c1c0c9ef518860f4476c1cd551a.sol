1 contract EtherandomProxy {
2   address owner;
3   address etherandom;
4   address callback;
5 
6   function EtherandomProxy() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyAdmin {
11     if (msg.sender != owner) throw;
12     _
13   }
14 
15   function getContractAddress() public constant returns (address _etherandom) {
16     return etherandom;
17   }
18   
19   function setContractAddress(address newEtherandom) onlyAdmin {
20     etherandom = newEtherandom;
21   }
22 
23   function getCallbackAddress() public constant returns (address _callback) {
24     return callback;
25   }
26   
27   function setCallbackAddress(address newCallback) onlyAdmin {
28     callback = newCallback;
29   }
30   
31   function kill() onlyAdmin {
32     selfdestruct(owner);
33   }
34 }