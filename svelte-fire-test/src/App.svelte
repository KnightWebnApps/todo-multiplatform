<script>
  import { FirebaseApp, User, Doc, Collection } from "sveltefire";
  import { onMount } from 'svelte';
  import firebase from "firebase/app";
  import "firebase/firestore";
  import "firebase/auth";
  import "firebase/performance";
  import "firebase/analytics";

  let firebaseConfig = {
    apiKey: "AIzaSyBAJu1gSAsg5BArW7q_djfkJlrbRJUiQJk",
    authDomain: "todo-f4613.firebaseapp.com",
    databaseURL: "https://todo-f4613.firebaseio.com",
    projectId: "todo-f4613",
    storageBucket: "todo-f4613.appspot.com",
    messagingSenderId: "432963891377",
    appId: "1:432963891377:web:18506f3cfab0eb5ecd7290",
    measurementId: "G-02TR05RPVP"
  };

  firebase.initializeApp(firebaseConfig);

  let todo = '';
  let sesStorage = null;
  onMount(() => sesStorage = sessionStorage)
  
</script>

<main>

  {#if !firebaseConfig.projectId}
    <strong>Step 0</strong>
    Create a
    <a href="https://firebase.google.com/">Firebase Project</a>
    and paste your web config into
    <code>App.svelte</code>
    .
  {/if}

  <!-- 1. 🔥 Firebase App -->
  <FirebaseApp {firebase}>


    <!-- 2. 😀 Get the current user -->
    <User persist={sesStorage} let:user let:auth>
      Howdy 😀! User
      <em>{user.uid}</em>

      <button on:click={() => auth.signOut()}>Sign Out</button>

      <div slot="signed-out">

        <button on:click={() => auth.signInAnonymously()}>
          Sign In Anonymously
        </button>

        <button on:click={()=> auth.signInWithPopup(firebase.auth.GoogleAuthProvider())}>Sign In With Google</button>

      </div>
      
        <input placeholder="Add todo" bind:value={todo}>
      
      


      <!-- 3. 📜 Get a Firestore document owned by a user -->
      <Collection 
        path={'todos'} 
        query={(ref) => ref.where('uid', '==', user.uid)} 
        let:data={todos}
        let:ref={todoRef}
        log
      >
      <button
        type="submit"
        on:click={() => {
          todoRef.add({
            uid: user.uid,
            title: todo,
            createdAt: Date.now()
          });

          todo = '';

          }
        }
        formaction={()=> {
          todoRef.add({
            uid: user.uid,
            title: todo,
            createdAt: Date.now()
          });

          todo = '';
        }}
        >
        Add
      </button>
      {#each todos as todo}
        <h1>{todo.title}</h1>
        {todo.createdAt}
        <button 
          on:click={()=> todo.ref.delete()}
        >
        Delete
        </button>
      {/each}

      <div slot='fallback'>
        An Error Occured
      </div>
      </Collection>
      
    </User>
  </FirebaseApp>

</main>


<!-- Styles -->
<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  form input {
    border-radius: 10px;
    width: 100%;
  }

  h1,
  em {
    color: #ff3e00;
  }

  hr {
    height: 1px;
    border: none;
    background: rgb(195, 195, 195);
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>