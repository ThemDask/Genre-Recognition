const selectedsong = document.getElementById("songinput");

function analyze() { /* send the selected song as a JSON dict to 
                        be analysed  and return the genre */

    const mysong = selectedsong.value 

    const value = {mysong} 
    const passthesong = JSON.stringify(value); /*converts song name to json string*/

    console.log(passthesong) 
    //console.log(x)

    var mydata =  x 
    console.log(mydata)

    $.ajax({    /* passes the .json to python */
        url:"/",
        type:"POST",
        contentType: "application/json",
        data: JSON.stringify(passthesong)});


    $.ajax({    /* returns the genre as a variable */
        url:"/",
        type:"GET",
        contentType: "application/json",
        success: x});
}



