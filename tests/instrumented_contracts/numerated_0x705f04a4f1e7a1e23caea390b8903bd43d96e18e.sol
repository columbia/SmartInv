1 contract mortal {
2     address private owner;
3     /* this function is executed at initialization and sets the owner of the contract */
4     function mortal() { owner = msg.sender; }
5     /* Function to recover the funds on the contract */
6     function kill() { if (msg.sender == owner) selfdestruct(owner); }
7 }
8 
9 contract EtherPennySlots is mortal {
10     address private hotAccount = 0xD837ACd68e7dd0A0a9F03d72623d5CE5180e3bB8;
11     address public lastWinner;
12     address[]  private currentTicketHolders;
13     
14     function placeWager() {
15        if (msg.value > 0 finney && msg.value < 51 finney) {
16             uint i = 0;
17             for (i = 0; i < msg.value; i++){
18                 currentTicketHolders.length++;
19                 currentTicketHolders[currentTicketHolders.length-1] = msg.sender; 
20             }
21                        
22             if (this.balance >= 601 finney) {
23                 uint nr_tickets = currentTicketHolders.length;
24                 uint randomTicket = block.number % nr_tickets;
25                 address randomEntry = currentTicketHolders[randomTicket];
26                 if (hotAccount.send(100 finney) && randomEntry.send(500 finney)) {
27                     lastWinner = randomEntry;
28                     currentTicketHolders.length = 0;
29                 }
30             } 
31         }
32     }
33 }