1 //! Github Hinting contract.
2 //! By Gav Wood (Ethcore), 2016.
3 //! Released under the Apache Licence 2.
4 
5 contract GithubHint {
6     struct Entry {
7         string accountSlashRepo;
8         bytes20 commit;
9         address owner;
10     }
11     
12     modifier when_edit_allowed(bytes32 _content) { if (entries[_content].owner != 0 && entries[_content].owner != msg.sender) return; _ }
13     
14     function hint(bytes32 _content, string _accountSlashRepo, bytes20 _commit) when_edit_allowed(_content) {
15         entries[_content] = Entry(_accountSlashRepo, _commit, msg.sender);
16     }
17 
18     function hintURL(bytes32 _content, string _url) when_edit_allowed(_content) {
19         entries[_content] = Entry(_url, 0, msg.sender);
20     }
21 
22     function unhint(bytes32 _content) when_edit_allowed(_content) {
23         delete entries[_content];
24     }
25     
26     mapping (bytes32 => Entry) public entries;
27 }