Google Drive organization and cleanup workflow:

1. **Analyze Current State**:
   - Storage usage: `gog drive about --plain`
   - List folders: `gog drive ls --query="mimeType='application/vnd.google-apps.folder'" --max=100 --plain`
   - Files in root: `gog drive ls --query="'root' in parents and mimeType!='application/vnd.google-apps.folder'" --max=100 --plain`

2. **Find Duplicates** (same name, similar size):
   - List all files with names and sizes
   - Group by filename
   - Flag potential duplicates (same name, size within 10%)

3. **Find Large Files** (>100MB):
   ```bash
   gog drive ls --query="quotaBytesUsed>104857600" --order-by="quotaBytesUsed desc" --max=50 --plain
   ```

4. **Find Old Files** (not modified in 2+ years):
   ```bash
   gog drive ls --query="modifiedTime<'2024-01-01'" --order-by="modifiedTime asc" --max=100 --plain
   ```

5. **Identify Organization Needs**:
   - Files in root → suggest target folders based on type/name
   - Use folder hierarchy from SKILL.md

6. **Propose Actions** (wait for user approval):

   **Folders to Create:**
   ```
   - Drive/Documents/Personal/
   - Drive/Projects/Active/
   - Drive/Archive/By-Year/2023/
   ```

   **Files to Move:**
   ```
   | File | Current | Suggested Folder |
   |------|---------|------------------|
   | tax_2023.pdf | root | Documents/Finance/Taxes/ |
   | resume.docx | root | Documents/Work/CV-Portfolio/ |
   ```

   **Potential Duplicates:**
   ```
   | Name | Location 1 | Location 2 | Action |
   |------|------------|------------|--------|
   | doc.pdf | /root | /Backup | Review |
   ```

   **Large Files to Review:**
   ```
   | Name | Size | Last Modified | Suggestion |
   |------|------|---------------|------------|
   | old_backup.zip | 2GB | 2020-05-01 | Archive or delete |
   ```

7. **Execute** (after confirmation only):
   ```bash
   # Create folder
   gog drive mkdir "Documents/Finance/Taxes" --parent=ROOT_ID

   # Move file
   gog drive move FILE_ID --parent=FOLDER_ID

   # Delete (to trash)
   gog drive delete FILE_ID
   ```

8. **Report Results**:
   - Folders created
   - Files moved
   - Files deleted
   - Remaining items in root
   - Storage recovered (if any)

Always ask for confirmation before moving or deleting files.
