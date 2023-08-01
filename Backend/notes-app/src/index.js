const express = require("express")
const app = express()

app.use(express.json())

require("./db/mongoose")
const Note = require("./model/notes")
app.listen(3000, ()=>{
    console.log("Server is up and running")
})
app.post("/notes",async (req,res)=>{
    console.log("post request-------")
    try{
    const note = Note(req.body)
    await note.save()
    res.status(200).send(note)
    }
    catch(err)
    {
        console.log(err)
        res.status(400).send(err)
    }
})

app.get("/notes",async (req,res)=>{
    console.log("get request------")
    try{
    const note = await Note.find({})
    res.status(200).send(note)
    }
    catch(err)
    {
        console.log(err)
        res.status(400).send(err)
    }
})

app.patch("/notes/:id", async (req,res)=>{
    try{
    const note = await Note.findById(req.params.id)
    if (!note) {
        res.status(500).send()
        return
    }
    note.note = req.body.note
    await note.save()
    res.status(200).send(note)
    }
    catch(err)
    {
        res.status(400).send(err)
    }

})

app.delete("/notes/:id", async (req,res)=>{
    try{
    const note = await Note.findByIdAndDelete(req.params.id)
    if (!note) {
        res.status(500).send()
        return
    }
    res.status(200).send("Note has been deleted")
    }
    catch(err)
    {
        res.status(400).send(err)
    }

})