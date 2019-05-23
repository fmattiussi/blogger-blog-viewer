## Blogger Blog Viewer
### Introduzione
Questa è una app al fine di testare e fornire un modello concreto di utilizzo delle API di Blogger in Swift 5 e iOS 12.2, in questa demo l'interazione con le API si limita al retrieve dei commenti di un post, della cronologia dei post e del singolo post (derivato dalla cronologia dei post). È scritta in puro Swift 5 e non dipende da alcuna libreria, consiglio di usare il modello di retrieve/post dei dati usato nel file Blogger.swift perchè è ottimizzato per le nuove versioni di Swift.

### Design
![Homescreen](https://github.com/fmattiussi/blogger-blog-viewer/blob/master/Schermata%202019-05-23%20alle%2017.39.51.png)I post vengono presentati in una collectionView con un design material e con colori ispirati al blog di provenienza (il mio, [dick-cat](http://www.dick-cat.it)). La barra di ricerca non è stata ancora implementata, quindi non è dispnibile all' utilizzo.
![Vista Post](https://github.com/fmattiussi/blogger-blog-viewer/blob/master/Schermata%202019-05-23%20alle%2017.40.19.png)I post vengono presentati in una view con il titolo del post, una textView e un pulsante per i commenti (se non ci sono, il pulsante è automaticamente disabilitato). Il testo nella textView è un NSAttributedString quindi un testo attribuito e che mostrerà il font usato nella _stesura_ del post (su Blogger il font predefinito nell'editor è Times New Roman, anche se quello che verrà mostrato sulla pagina è diverso, l'HTML ottenuto conterrà il font dell'editor). Si può condividere l'url del blog con la ShareAction in alto (da testare su device reali per avere un menù completo)
![Vista Commenti](https://github.com/fmattiussi/blogger-blog-viewer/blob/master/Schermata%202019-05-23%20alle%2017.40.31.png)La vista commenti viene presentata come una tableView contenente il commento e l'autore. In basso viene mostrarto il numero di essi.

### Dettagli
* Compilato su Xcode 10.2.1
* Scritto con Swift 5
* Testato sul simulatore su iPhone Xr con iOS 12.2

### Note
L'ho testato su iPhone Xr e costruito le views su una storyboard con la vista di iPhone Xr, su altre dimensioni di schermo potrebbero dare problemi le cells che non si ridimensionano automaticamente

### TO-DOs
Non credo che (almeno in questi mesi) ritornerò su questa demo, perché è una demo e la considero chiusa, tuttavia ci sono delle implementazioni e miglioramenti da poter eseguire. Se vi interessasse e se vorrete farli voi al posto mio apprezzerò sicuramente una request. Le principali implementazioni da fare sono:

* **La barra di ricerca**: non è stata implementata e richiede un lavoro un po' più grande rispetto alle altre implementazioni. Non dovrebbe essere difficile costruire un metodo dentro la classe Blogger, la documentazione sulle API relative alla ricerca sono [qui](https://developers.google.com/blogger/docs/3.0/using#SearchingForAPost).
* **Adattare le celle della collectionView** a tutte le dimensioni di schermi (almeno iPhone)
