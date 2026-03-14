pipeline {
    agent none  // Assign per stage

    triggers {
        githubPush()  // Auto-trigger on GitHub push
    }

    stages {

        stage('Checkout') {
            agent { label 'built-in' }  // Run on Jenkins master
            steps {
                checkout scm
                echo "✅ Code checked out"
            }
        }

        stage('Deploy to nginx-web') {
            agent { label 'built-in' }  // Master has Docker socket
            steps {
                sh '''
                    echo "📦 Copying files to nginx-web container..."
                    docker cp index.html  nginx-web:/usr/share/nginx/html/
                    docker cp style.css   nginx-web:/usr/share/nginx/html/
                    docker cp script.js   nginx-web:/usr/share/nginx/html/
                    echo "🔄 Reloading Nginx..."
                    docker exec nginx-web nginx -s reload
                    echo "✅ Deployment complete!"
                '''
            }
        }
    }

    post {
        success { echo '🎉 Pipeline SUCCESS — site is live at http://<your-host-ip>' }
        failure  { echo '❌ Pipeline FAILED — check logs above' }
    }
}
```

> **Why `built-in`?** The Docker socket is only mounted on `jenkins-master`. In Jenkins, the master node's label is `built-in`. This ensures `docker cp` runs on the right node.

---

## Step 3 — Create Jenkins Pipeline Job

1. Open Jenkins → **New Item** → name it (e.g. `static-web-deploy`) → choose **Pipeline** → OK
2. Under **General** → check **GitHub project** → paste your repo URL
3. Under **Build Triggers** → check ✅ **GitHub hook trigger for GITScm polling**
4. Under **Pipeline** → set:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: your GitHub repo URL
   - Branch: `*/main` (or `*/master`)
   - Script Path: `Jenkinsfile`
5. Click **Save**

---

## Step 4 — GitHub Webhook (auto-trigger on push)

Go to your GitHub repo → **Settings** → **Webhooks** → **Add webhook**

| Field | Value |
|---|---|
| Payload URL | `http://<your-host-ip>:8081/github-webhook/` |
| Content type | `application/json` |
| Which events? | Just the **push** event |

> ⚠️ If your Fedora machine is on a **local network** (not public internet), GitHub can't reach it directly. Two options:
> - Use **[ngrok](https://ngrok.com/)**: `ngrok http 8081` → use the ngrok URL as webhook
> - Or switch to **SCM Polling** in Jenkins (less elegant but works offline): under Build Triggers, check **Poll SCM** and set schedule `H/2 * * * *` (checks every 2 min)

---

## Step 5 — Test it

1. Run the pipeline **once manually** first (Build Now) to confirm it works
2. Then make any change to `index.html`, commit and push to GitHub
3. Jenkins should auto-trigger within seconds
4. Visit `http://<your-host-ip>` → you'll see your updated page

---

## Flow Summary
```
git push → GitHub → Webhook → Jenkins (port 8081)
                                    │
                              Checkout code
                                    │
                              docker cp files
                              → nginx-web container
                                    │
                              docker exec nginx -s reload
                                    │
                              Site live at :80 ✅
