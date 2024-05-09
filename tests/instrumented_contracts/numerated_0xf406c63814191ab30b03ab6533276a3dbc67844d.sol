1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract ClassicOnlyTransfer {
6 
7   // Fork oracle to use
8   AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
9 
10   address public transferTo = 0x502f9aa95d45426915bff7b92ef90468b100cc9b;
11   
12   function () {
13     if ( amIOnTheFork.forked() ) throw;
14 
15     transferTo.send( msg.value );
16   }
17   
18 }