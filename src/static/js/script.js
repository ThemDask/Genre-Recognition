const selectedsong = document.getElementById("songinput");

function analyze() { /* send the selected song as a JSON dict to 
                        be analysed  and return the genre */

    const mysong = selectedsong.value 
    /*console.log(mysong)*/

    const value = {mysong} 
    const passthesong = JSON.stringify(value);
    console.log(passthesong) /*converts song name to json string*/

    $.ajax({    /* passes the .json to python */
        url:"/test",
        type:"POST",
        contentType: "application/json",
        data: JSON.stringify(passthesong)});
}



