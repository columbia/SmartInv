1 /*
2 this smartcontract used to store documents text on the Ethereum blockchain
3 */
4 
5 contract ProofOfExistence{
6 
7     /* ---- Public variables: */
8     string public created;
9     address public manager; // account that adds info to this smartcontract
10     uint256 public index;   // record's numbers and number of records
11     mapping (uint256 => Doc) public docs; // index => Doc
12     // to get Doc obj call ProofOfExistence.docs(index);
13 
14     /* ---- Stored document structure: */
15 
16     struct Doc {
17         string publisher; // publisher's email
18         uint256 publishedOnUnixTime; // block timestamp (block.timestamp)
19         uint256 publishedInBlockNumber; // block.number
20         string text; // text of the document
21     }
22 
23     /* ---- Constructor: */
24 
25     function ProofOfExistence(){
26         manager = msg.sender;
27         created = "cryptonomica.net";
28         index = 0; //
29     }
30 
31     /* ---- Event:  */
32     // This generates a public event on the blockchain that will notify clients. In 'Mist' SmartContract page enable 'Watch contract events'
33     event DocumentAdded(uint256 indexed index,
34                         string indexed publisher,
35                         uint256 publishedOnUnixTime,
36                         string indexed text);
37 
38     /* ----- Main method: */
39 
40     function addDoc(string _publisher, string _text) returns (uint256) {
41         // authorization
42         if (msg.sender != manager) throw;
43         // document number
44         index += 1;
45         // add document data:
46         docs[index] = Doc(_publisher, now, block.number, _text);
47         // add event
48         DocumentAdded(index,
49                       docs[index].publisher,
50                       docs[index].publishedOnUnixTime,
51                       docs[index].text);
52         // return number of the stored document
53         return index;
54     }
55 
56     /* ---- Utilities: */
57 
58     function () {
59         // This function gets executed if a
60         // transaction with invalid data is sent to
61         // the contract or just ether without data.
62         // We revert the send so that no-one
63         // accidentally loses money when using the
64         // contract.
65         throw;
66     }
67 
68 }