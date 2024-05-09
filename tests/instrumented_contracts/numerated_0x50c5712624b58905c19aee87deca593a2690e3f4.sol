1 contract Docsign
2 {
3     //Fire when document hash is added to contract
4     event Added(address indexed _from);
5 
6     //Fire when contract is deployed on the blockchain
7     event Created(address indexed _from);
8 
9 
10     struct Document {
11         uint version;
12         string name;
13         address creator;
14         string hash;
15         uint date;
16     }
17     Document[] public a_document;
18     uint length;
19 
20     // Constructor. Can be used to track contract deployment
21     function Docsign() {
22         Created(msg.sender);
23     }
24 
25     function Add(uint _version, string _name, string _hash) {
26         a_document.push(Document(_version,_name,msg.sender, _hash, now));
27         Added(msg.sender);
28     }
29     // Get number of element in Array a_document (does not used GAS)
30     function getCount() public constant returns(uint) {
31         return a_document.length;
32     }
33     
34     // fallback function (send back ether if contrat is used as wallet contract)
35     function() { throw; }
36 
37 }