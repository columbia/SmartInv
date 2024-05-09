1 contract Devcon2Interface {
2     function isTokenOwner(address _owner) constant returns (bool);
3     function ownedToken(address _owner) constant returns (bytes32 tokenId);
4 }
5 
6 
7 contract Survey {
8     Devcon2Interface public devcon2Token;
9 
10     // Mapping from tokenId to boolean noting whether this token has responded.
11     mapping (bytes32 => bool) public hasResponded;
12     
13     // The timestamp when this survey will end.
14     uint public surveyEndAt;
15 
16     // The question we wish to ask the token holders.
17     string public question;
18 
19     // An array of answer options.
20     bytes32[] public responseOptions;
21 
22     // Helper for accessing the number of options programatically.
23     uint public numResponseOptions;
24 
25     // Histogram of the responses as a mapping from option index to number of
26     // responses for that option.
27     mapping (uint => uint) public responseCounts;
28 
29     // Total number of responses.
30     uint public numResponses;
31 
32     // Event for logging response submissions.
33     event Response(bytes32 indexed tokenId, uint responseId);
34 
35     /// @dev Sets up the survey contract
36     /// @param tokenAddress Address of Devcon2 Identity Token contract.
37     /// @param duration Integer duration the survey should remain open and accept answers.
38     /// @param _question String the survey question.
39     /// @param _responseOptions Array of Bytes32 allowed survey response options.
40     function Survey(address tokenAddress, uint duration, string _question, bytes32[] _responseOptions) {
41         devcon2Token = Devcon2Interface(tokenAddress);
42         question = _question;
43         numResponseOptions = _responseOptions.length;
44         for (uint i=0; i < numResponseOptions; i++) {
45             responseOptions.push(_responseOptions[i]);
46         }
47         surveyEndAt = now + duration;
48     }
49 
50     /// @dev Respond to the survey
51     /// @param responseId Integer index of the response option being submitted.
52     function respond(uint responseId) returns (bool) {
53         // Check our survey hasn't ended.
54         if (now >= surveyEndAt) return false;
55 
56         // Only allow token holders
57         if (!devcon2Token.isTokenOwner(msg.sender)) return false;
58 
59         // Each token has a unique bytes32 identifier.  Since tokens are
60         // transferable, we want to use this value instead of the owner address
61         // for preventing the same owner from responding multiple times.
62         var tokenId = devcon2Token.ownedToken(msg.sender);
63 
64         // Sanity check.  The 0x0 token is invalid which means something went
65         // wrong.
66         if (tokenId == 0x0) throw;
67 
68         // verify that this token has not yet responded.
69         if (hasResponded[tokenId]) return false;
70 
71         // verify the response is valid
72         if (responseId >= responseOptions.length) return false;
73 
74         responseCounts[responseId] += 1;
75 
76         // log the response.
77         Response(tokenId, responseId);
78 
79         // Mark this token as having responded to the question.
80         hasResponded[tokenId] = true;
81 
82         // increment the response counter
83         numResponses += 1;
84     }
85 }
86 
87 
88 contract MainnetSurvey is Survey {
89     function MainnetSurvey(uint duration, string _question, bytes32[] _responseOptions) Survey(0xabf65a51c7adc3bdef0adf8992884be38072c184, duration, _question, _responseOptions) {
90     }
91 }
92 
93 
94 contract ETCSurvey is MainnetSurvey {
95     function ETCSurvey() MainnetSurvey(
96             2 weeks,
97             "Do plan to pursue any development or involvement on the Ethereum Classic blockchain",
98             _options
99         )
100     {
101         bytes32[] memory _options = new bytes32[](4);
102         _options[0] = "No Answer";
103         _options[1] = "Yes";
104         _options[2] = "No";
105         _options[3] = "Undecided";
106     }
107 }