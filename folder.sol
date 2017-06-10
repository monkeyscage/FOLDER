contract UniversalFolder{

//this folder content is organized by a tree
//Entities are listed at a given position,
//they can be deleted and the hole is removed,
//reconnecting the prev and next exposed entities on the sequence
//All previous EE remains in the logs and can be accessed by index

address public owner;
address public controller;        //can be used as secondary admin
string standard="ETHFOLDER.1.0";  //the blog standard
uint public EEcount;              // the amount of EE (Ethereum Entities) registered
uint public totExposed;           //the amount of EE exposed by the log
bool public isOpen;
 
//creation
function UniversalFolder(address setOwner) {
owner=setOwner;
EEcount=1;
totExposed=1;
isOpen=false;
logs.push(log(o,0,1));
}

//change owner
function manager(address newOwner)returns(bool){
if(msg.sender!=owner)throw;
owner=newOwner;
return true;
}

//open-close Folder (so anyone can drop any EE inside)
function openFolder(bool open)returns(bool){
if((msg.sender!=owner)&&(msg.sender!=controller))throw;
isOpen=open;
return true;
}

//change owner
function setController(address newController)returns(bool){
if(msg.sender!=owner)throw;
controller=newController;
return true;
}
 
//add a new EE at the end of the log
//if the folder is open anyone can do it
function addEntity(address EE) returns(bool){
if(!isOpen){if((msg.sender!=owner)&&(msg.sender!=controller))throw;}
logs.push(log(EE,EEcount-1,EEcount+1));
EEcount++;
totExposed++;
return true;
}


//delete a specific EE at a given index
function deleteEE(uint index) returns(bool){
if((msg.sender!=owner)&&(msg.sender!=controller))throw;
log l=logs[index];
logs[l.prev].next=l.next;
logs[l.next].prev=l.prev;
totExposed--;
return true;
}
 
 
//read the logs by index
//this is the standard BLOCKLOG call
//returns a custom output specifying the index of the next Exposed EE on the sequence
function readLog(uint i)constant returns(uint,address,uint,uint,uint){
log l=logs[i];
return(logs.length,l.EE,l.prev,l.next,totExposed);
}


//the logs container
log[] logs;
//used to know in advance the logs structure
string public logInterface="a-Log|u-PrevLog|u-NextLog|u-TotExposed";

    struct log{
    address EE;
    uint prev;
    uint next;
   }
 
 
//destroy folder
function kill(){
if (msg.sender != owner)throw;
selfdestruct(owner);
}
 
}
